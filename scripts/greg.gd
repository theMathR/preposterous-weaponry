extends Damageable

const SPEED = 1024.
const ACCELERATION_SPEED = 4096*2.
const JUMP_VELOCITY = -2560.-256.

var was_on_floor = false
var is_walking = false
var knockback: float = 0
var face_expression = 0

var blink = 0

func _ready() -> void:
	Global.Greg = self
	global_position = Global.saved_position
	
	$Sprites/Gun/Sprite2D/Barrel.wielder = self

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Walk
	var mouse = get_local_mouse_position()- $Sprites.position
	if mouse.x * $Sprites.scale.x < 0:
		$Sprites.scale.x *= -1
		$Sprites/Feet.rotation *= -1
	var walk = Input.get_axis("walk_left", "walk_right")
	$AnimationTree['parameters/movement/walk/direction/transition_request'] = 'forwards' if mouse.x * walk > 0 else 'backwards'
	$AnimationTree["parameters/movement/land_walk/direction/transition_request"] = $AnimationTree['parameters/movement/walk/direction/transition_request']
	if walk:
		velocity.x = move_toward(velocity.x, walk * SPEED, ACCELERATION_SPEED * delta)
		is_walking = true
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION_SPEED * delta)
		is_walking = false
	
	# Handle jump
	if not is_on_floor() and was_on_floor:
		$CoyoteTime.start()
	var coyote_time = not $CoyoteTime.is_stopped()
	if (is_on_floor() or coyote_time) and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		$AnimationTree['parameters/movement/playback'].travel('jump')
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2

	# Face the camera
	$AnimationTree['parameters/is_frontfacing/transition_request'] = 'true' if abs(mouse.x) < 100 else 'false'
	
	# Look at mouse
	var head_direction: int = floor(abs(mouse.angle_to(Vector2.UP))/PI*5)+1
	if mouse.length_squared() < 10000:
		head_direction = 0
	$Sprites/Body/Head.texture.region.position.x = 128 * head_direction
	$Sprites/Gun.look_at($Sprites.global_position+mouse.normalized() * 500)
	
	# Head expression
	$Sprites/Body/Head.texture.region.position.y =  (face_expression + (blink if face_expression == 2 else 0))*128

	move_and_slide()
	
	# Bump on walls
	$Sprites/Armor.scale.x = move_toward($Sprites/Armor.scale.x, 1, delta / $Sprites/Armor.scale.x)
	$Sprites/Armor.scale.y = move_toward($Sprites/Armor.scale.y, 1, delta / $Sprites/Armor.scale.y)
	for i in get_slide_collision_count():
		var collision_normal = get_slide_collision(i).get_normal()
		var angle = collision_normal.angle()
		if 0 <= angle and angle <= PI+.01:
			$HitSound.pitch_scale = randf_range(0.8,1.2)
			$HitSound.play()
			velocity.x = collision_normal.x * SPEED
			$Sprites/Armor.scale = Vector2.ONE + collision_normal/5 * Vector2(sign(walk),-0.5)
 
	# To make the feet not go through the ground
	# This was REALLY tough to get right :/
	if not is_on_floor():
		$FeetCollision.global_position.y = max($Sprites/Feet/FootB.global_position.y,$Sprites/Feet/FootA.global_position.y) - 70
	else:
		var diff = $FeetCollision.global_position.y + 70 - max($Sprites/Feet/FootB.global_position.y,$Sprites/Feet/FootA.global_position.y) 
		$FeetCollision.position.y -= diff
		position.y += diff
	$FeetCollision.position.x = $Sprites/Feet.position.x * $Sprites.scale.x
	# At an angle
	#$Sprites/Feet.rotation = move_toward($Sprites/Feet.rotation, (get_floor_normal().angle() + PI/2) * $Sprites.scale.x if is_on_floor() else 0, delta * 5)

	# Fun rotation hack
	$Sprites/Feet/FootA/Sprite2D.rotation = 2*$Sprites/Feet/FootA.rotation if $Sprites/Feet/FootA.scale.x == -1 else 0

	# Feet follow speed
	if not is_on_floor():
		$Sprites/Feet.position.x = move_toward($Sprites/Feet.position.x, $Sprites.scale.x*walk*50,  delta*100)
	else:
		$Sprites/Feet.position.x = move_toward($Sprites/Feet.position.x, 0,  delta*SPEED/2)

	# Handle gun knockback
	var parts_count = $Sprites/Gun/Sprite2D.get_child_count()-1.
	var adjusted_knockback = knockback/parts_count
	$Sprites/Gun/Sprite2D.position.x = -50*adjusted_knockback
	knockback = move_toward(adjusted_knockback, 0, delta*5) * parts_count
	
	was_on_floor = is_on_floor()

	# Shoot da guns!
	if Input.is_action_pressed("shoot"):
		for part in $Sprites/Gun/Sprite2D.get_children():
			if part is not GunPart: continue
			part.shoot()
		set_face(2)
	elif Input.is_action_just_released("shoot"):
		for part in $Sprites/Gun/Sprite2D.get_children():
			if part is not GunPart: continue
			part.release()
		

func acquire_upgrade(upgrade: PackedScene):
	var part: GunPart = upgrade.instantiate()
	
	var direction = 1 if $Sprites/Gun/Sprite2D.get_child_count() % 2 else 0
	var support_part: GunPart
	if direction == 0:
		support_part = $Sprites/Gun/Sprite2D.get_child(2)
	else:
		support_part = $Sprites/Gun/Sprite2D.get_child(-1)
	
	part.position.x = randf_range(220,270)
	part.position.y = support_part.position.y + (randf_range(-support_part.height, -support_part.height*3/4) if direction else randf_range(support_part.height*3/4, support_part.height)) + (randf_range(-part.height, 0) if direction else randf_range(0, part.height))
	
	part.wielder = self
	
	$Sprites/Gun/Sprite2D.add_child(part)
	if direction == 0:
		$Sprites/Gun/Sprite2D.move_child(part, 2)
	
	part.deploy()
	$AcquireSound.play()


func set_face(i):
	if face_expression > i: return
	face_expression = i
	$HeadAnimTimer.start()


func _on_blink_timer_timeout():
	if face_expression == 1: face_expression = 0
	elif face_expression == 0 and randi() % 30 == 0: face_expression = 1
	blink = 1-blink


func _on_head_anim_timer_timeout():
	face_expression = 0

func _on_death_particles_finished():
	pass

func damage(x):
	super.damage(x)
	$CanvasLayer/Control/Health.shake(100)

func die():
	var death_particles = load('res://scenes/death_particles.tscn').instantiate()
	death_particles.global_position = $Sprites.global_position
	death_particles.set_texture_and_material(death_texture, material)
	get_tree().create_timer(2).timeout.connect(Global.respawn)
	get_parent().add_child(death_particles)
	hide()
	process_mode = PROCESS_MODE_DISABLED
