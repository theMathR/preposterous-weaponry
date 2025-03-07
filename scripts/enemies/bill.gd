extends Damageable

@export var minimum_dps_to_beat = 20.

const ACCELERATION_SPEED = 600.

var eye_expression = 0
var mouth_expression = 0

var blink = 0

func _ready() -> void:
	$AnimationPlayer.play("idle")
	max_hp = minimum_dps_to_beat * 2
	hp = max_hp
	
	# Randomized appearance
	material.set_shader_parameter('green_scale', randf_range(0.5,1.5))
	material.set_shader_parameter('grayscale_color', Color.from_hsv(randf(), randf()/4, 1))

func damage(dmg):
	super.damage(dmg)
	if hp<max_hp-minimum_dps_to_beat: set_face(2) # Damage face

func _physics_process(delta: float) -> void:
	# Heal damage
	heal(minimum_dps_to_beat*delta)
	
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Look at Greg
	$Sprites/Eye/Watch.position = 40 * (Global.Greg.position - global_position).normalized()
	
	# Head expression
	$Sprites/Eye/Eye.texture.region.position.y = eye_expression * 180
	$Sprites/Mouth.texture.region.position.y = mouth_expression * 122

	velocity.x = 0# Don't want that guy to move horizontally at all!
	move_and_slide()
	

func _on_blink_timer_timeout():
	if eye_expression == 1: eye_expression = 0
	elif eye_expression == 0 and randi() % 30 == 0: eye_expression = 1
	blink = 1-blink

func set_face(i):
	if eye_expression > i: return
	eye_expression = i
	if i==2: mouth_expression = 1
	$HeadAnimTimer.start()

func _on_head_anim_timer_timeout():
	eye_expression = 0
	mouth_expression = 0
