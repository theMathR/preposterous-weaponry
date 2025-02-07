class_name Damageable
extends CharacterBody2D

@export var max_hp: int = 3
@onready var hp = max_hp
var shake_value = 0.

func damage(dmg: int):
	hp -= dmg
	shake_value += float(dmg)/max_hp
	if hp <= 0:
		$Sprites.hide()
		$DeathParticles.restart()
		process_mode = PROCESS_MODE_DISABLED

func shake(delta):
	if shake_value < 0.025: return
	$Sprites.position = Vector2.from_angle(randf_range(0, TAU)) * shake_value * 20
	shake_value = move_toward(shake_value, 0, delta * shake_value)

# Set DeathParticles to process mode Always and hook up this signal
func _on_death_particles_finished():
	queue_free()
