class_name Damageable
extends CharacterBody2D

@export var max_hp: int = 3
@export var death_texture: Texture2D
@onready var hp = max_hp
var shake_value = 0.


func damage(dmg: int):
	hp -= dmg
	shake_value += float(dmg)/max_hp
	if hp <= 0:
		die()

func die():
	var death_particles = load('res://scenes/death_particles.tscn').instantiate()
	death_particles.global_position = $Sprites.global_position
	death_particles.set_texture_and_material(death_texture, material)
	get_parent().add_child(death_particles)
	queue_free()

func shake(delta):
	if shake_value < 0.025: return
	$Sprites.position = Vector2.from_angle(randf_range(0, TAU)) * shake_value * 20
	shake_value = move_toward(shake_value, 0, delta * shake_value)
