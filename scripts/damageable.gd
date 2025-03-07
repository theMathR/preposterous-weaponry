class_name Damageable
extends CharacterBody2D

@export var max_hp: float = 3
@export var death_texture: Texture2D
@onready var hp = max_hp

func damage(dmg: float):
	if not hp: return
	hp -= dmg
	$Sprites.shake(dmg/max_hp*50)
	if hp <= 0:
		hp = 0
		die()

func heal(dmg: float):
	hp = clamp(hp + dmg, 0, max_hp)

func die():
	Global.shake_screen(50)
	var death_particles = load('res://scenes/death_particles.tscn').instantiate()
	death_particles.global_position = $Sprites.global_position
	death_particles.set_texture_and_material(death_texture, material)
	get_parent().add_child(death_particles)
	queue_free()
