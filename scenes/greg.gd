extends CharacterBody2D


const SPEED = 1024.
const ACCELERATION_SPEED = 4096*2.
const JUMP_VELOCITY = -2560.-256.

var was_on_floor = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Walk
	var mouse = get_local_mouse_position()
	if mouse.x * $Sprites.scale.x < 0:
		$Sprites.scale.x *= -1 
	if Input.is_action_pressed("walk") and abs(mouse.x) > 150:
		velocity.x = move_toward(velocity.x, sign(mouse.x) * min(1, abs(mouse.x/250)) * SPEED, ACCELERATION_SPEED * delta)
		$AnimationTree['parameters/movement/playback'].travel('walk')
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION_SPEED * delta)
		$AnimationTree['parameters/movement/playback'].travel('idle')

	# Handle jump.
	var on_floor = is_on_floor()
	if not on_floor:
		$AnimationTree['parameters/movement/playback'].travel('air')
		if was_on_floor:
			$CoyoteTime.start()
	var coyote_time = not $CoyoteTime.is_stopped()
	if (on_floor or coyote_time) and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		$AnimationTree['parameters/movement/playback'].travel('jump')
	was_on_floor = on_floor

	# Face the camera
	$AnimationTree['parameters/is_frontfacing/transition_request'] = 'true' if abs(mouse.x) < 100 else 'false'
	
	# Aim at mouse
	mouse = get_global_mouse_position()
	$Sprites/Body/Head.look_at(mouse)
	$Sprites/Gun.look_at(mouse)

	move_and_slide()
	
	# Bump on walls
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var angle = collision.get_normal().angle()
		if 0 <= angle and angle <= PI+.01:
			velocity.x = collision.get_normal().x * SPEED
 
	# To make the feet not go through the ground
	$Sprites.position.y = -138 + 116 - max($Sprites/FootB.position.y,$Sprites/FootA.position.y)
	$CollisionShape2D.position.y = -193  + 138 + $Sprites.position.y
	
	# Fun hack
	$Sprites/FootA/Sprite2D.rotation = 2*$Sprites/FootA.rotation if $Sprites/FootA.scale.x == -1 else 0
