#extends Shaking
extends HBoxContainer

@export var strenght = 1.
var shake_value := 0.
var noise := FastNoiseLite.new()

var hp: float = 0
var max_hp: float = 0
const SPEED = 50

func _ready():
	# Configure the FastNoiseLite instance.
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 20.0

func _physics_process(delta: float) -> void:
	if not (hp == Global.Greg.hp and max_hp == Global.Greg.max_hp): 
		hp = move_toward(hp, Global.Greg.hp, delta*SPEED)
		max_hp = move_toward(max_hp, Global.Greg.max_hp, delta*SPEED)
		$Label.text = str(int(hp))+'/'+str(int(max_hp))
	
	if not shake_value: return
	shake_value = move_toward(shake_value, 0, delta*shake_value*4)
	if shake_value < 0.01: shake_value = 0
	position = Vector2.from_angle(noise.get_noise_1d(Time.get_ticks_msec()/5.)*PI) * min(100, shake_value * strenght)

func shake(val):
	shake_value += val
	if shake_value > 20: shake_value = 20
