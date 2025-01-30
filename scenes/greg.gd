extends CharacterBody2D


const SPEED = 1024.
const ACCELERATION_SPEED = 4096*2.
const JUMP_VELOCITY = -2560.-256.

var was_on_floor = false
var on_floor = false
var is_walking = false
var knockback: float = 0

var blink = 0

func _physics_process(delta):
	on_floor = is_on_floor()
	print(get_floor_angle())
	
	# Add the gravity.
	if not on_floor:
		velocity += get_gravity() * delta
	
	# Walk
	var mouse = get_local_mouse_position()- $Sprites.position
	if mouse.x * $Sprites.scale.x < 0:
		$Sprites.scale.x *= -1 
	if Input.is_action_pressed("walk") and abs(mouse.x) > 150:
		velocity.x = move_toward(velocity.x, sign(mouse.x) * min(1, abs(mouse.x/250)) * SPEED, ACCELERATION_SPEED * delta)
		is_walking = true
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION_SPEED * delta)
		is_walking = false
	#$AnimationTree['parameters/movement/air/blend_position'] = velocity.x/SPEED * $Sprites.scale.x
	
	# Handle jump.
	if not on_floor and was_on_floor:
		$CoyoteTime.start()
	var coyote_time = not $CoyoteTime.is_stopped()
	if (on_floor or coyote_time) and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		$AnimationTree['parameters/movement/playback'].travel('jump')

	# Face the camera
	$AnimationTree['parameters/is_frontfacing/transition_request'] = 'true' if abs(mouse.x) < 100 else 'false'
	
	# Aim at mouse
	# i love this this is so cool
	var head_direction: int = floor(abs(mouse.angle_to(Vector2.UP))/PI*5)+1
	if mouse.length_squared() < 10000:
		head_direction = 0
	$Sprites/Body/Head.texture.region.position.x = 128 * head_direction
	
	$Sprites/Gun.look_at(get_global_mouse_position())
	
	# Head thing
	$Sprites/Body/Head.texture.region.position.y = (blink + 2 if knockback else 0)*128

	move_and_slide()
	
	# Bump on walls
	$Sprites/Armor.scale.x = move_toward($Sprites/Armor.scale.x, 1, delta / $Sprites/Armor.scale.x)
	$Sprites/Armor.scale.y = move_toward($Sprites/Armor.scale.y, 1, delta / $Sprites/Armor.scale.y)
	for i in get_slide_collision_count():
		var collision_normal = get_slide_collision(i).get_normal()
		var angle = collision_normal.angle()
		if 0 <= angle and angle <= PI+.01:
			velocity.x = collision_normal.x * SPEED
			$Sprites/Armor.scale = Vector2.ONE + collision_normal/5 * Vector2($Sprites.scale.x,-0.5)
 
	# To make the feet not go through the ground
	# This was tough to make :/
	if not on_floor:
		$FeetCollision.global_position.y = max($Sprites/Feet/FootB.global_position.y,$Sprites/Feet/FootA.global_position.y)
	else:
		var diff = $FeetCollision.global_position.y - max($Sprites/Feet/FootB.global_position.y,$Sprites/Feet/FootA.global_position.y) 
		$FeetCollision.position.y -= diff
		position.y += diff
	$FeetCollision.position.x = $Sprites/Feet.position.x

	# Fun rotation hack
	$Sprites/Feet/FootA/Sprite2D.rotation = 2*$Sprites/Feet/FootA.rotation if $Sprites/Feet/FootA.scale.x == -1 else 0

	# Feet follow speed
	if not  on_floor: $Sprites/Feet.position.x = move_toward($Sprites/Feet.position.x, abs(velocity.x/SPEED*50),  delta*100)
	else: $Sprites/Feet.position.x = move_toward($Sprites/Feet.position.x, 0,  delta*SPEED/2)

	# Handle gun knockback
	var parts_count = $Sprites/Gun/Sprite2D.get_child_count()-1.
	var adjusted_knockback = knockback/parts_count
	$Sprites/Gun/Sprite2D.position.x = -20*adjusted_knockback
	knockback = move_toward(adjusted_knockback, 0, max(delta,delta*knockback)) * parts_count
	
	was_on_floor = on_floor


func _on_blink_timer_timeout():
	blink = 1-blink
