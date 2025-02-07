extends Damageable

@export var dmg_multiplier = 1.0
@export var accuracy = 100.
@export var reaction_time = 0.5

const SPEED = 600.
const ACCELERATION_SPEED = 600.

@onready var greg = get_node('../../Greg')

var was_on_floor = false
var on_floor = false
var is_walking = false
var knockback: float = 0

var face_expression = 0

var blink = 0

func _ready() -> void:
	var gun_part = get_child(-1)
	if gun_part is GunPart:
		gun_part.reparent($Sprites/Gun/Sprite2D)
		gun_part.set_wielder(self)

func damage(dmg):
	super.damage(dmg)
	set_face(3)

func _process(delta: float) -> void:
	on_floor = is_on_floor()
	
	# Add the gravity
	if not on_floor:
		velocity += get_gravity() * delta
	
	# Walk
	var greg_pos = greg.global_position - global_position - $Sprites.position
	if greg_pos.x * $Sprites.scale.x < -50:
		$Sprites.scale.x *= -1
		$Sprites/Feet.rotation *= -1
	#var walk = Input.get_axis("walk_left", "walk_right")
	#if Input.is_action_pressed("walk") and abs(mouse.x) > 150:
		#walk = sign(mouse.x) * min(1, abs(mouse.x/250))
	#$AnimationTree['parameters/movement/walk/direction/transition_request'] = 'forwards' if mouse.x * walk > 0 else 'backwards'
	#$AnimationTree["parameters/movement/land_walk/direction/transition_request"] = $AnimationTree['parameters/movement/walk/direction/transition_request']
	var walk = 0
	if walk:
		velocity.x = move_toward(velocity.x, walk * SPEED, ACCELERATION_SPEED * delta)
		is_walking = true
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION_SPEED * delta)
		is_walking = false


	# Face the camera
	$AnimationTree['parameters/is_frontfacing/transition_request'] = 'true' if abs(greg_pos.x) < 100 else 'false'
	
	# Look at Greg
	var head_direction: int = floor(abs(greg_pos.angle_to(Vector2.UP))/PI*5)+1
	if head_direction > 5: head_direction = 5
	if greg_pos.length_squared() < 10000:
		head_direction = 0
	$Sprites/Head.texture.region.position.x = 200 * head_direction
	$Sprites/Gun.look_at($Sprites.global_position+greg_pos.normalized() * 500)
	
	# Head expression
	$Sprites/Head.texture.region.position.y = face_expression * 200

	move_and_slide()
	
	# Fun rotation hack
	$Sprites/Feet/FootA/Sprite2D.rotation = 2*$Sprites/Feet/FootA.rotation if $Sprites/Feet/FootA.scale.x == -1 else 0

	# Feet follow speed
	#if not on_floor:
		#$Sprites/Feet.position.x = move_toward($Sprites/Feet.position.x, abs(velocity.x/SPEED*50),  delta*100)
	#else:
		#$Sprites/Feet.position.x = move_toward($Sprites/Feet.position.x, 0,  delta*SPEED/2)

	# Handle gun knockback
	var parts_count = $Sprites/Gun/Sprite2D.get_child_count()
	if parts_count:
		print(name)
		var adjusted_knockback = knockback/parts_count
		$Sprites/Gun/Sprite2D.position.x = -50*adjusted_knockback
		knockback = move_toward(adjusted_knockback, 0, delta*5) * parts_count
		$Sprites/Gun/Sprite2D.get_child(0).shoot()
	shake(delta)

func _on_blink_timer_timeout():
	if face_expression == 1: face_expression = 0
	elif face_expression == 0 and randi() % 30 == 0: face_expression = 1
	blink = 1-blink

func set_face(i):
	if face_expression > i: return
	face_expression = i
	$HeadAnimTimer.start()

func _on_head_anim_timer_timeout():
	face_expression = 0
