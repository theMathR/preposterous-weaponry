class_name Damageable
extends CharacterBody2D

@export var max_hp: int = 3
@export var death_texture: Texture2D
@onready var hp = max_hp

func damage(dmg: int):
	hp -= dmg
	$Sprites.shake(dmg/float(max_hp)*50)
	if hp <= 0:
		hp = 0
		die()

func die():
	Global.shake_screen(50)
	var death_particles = load('res://scenes/death_particles.tscn').instantiate()
	death_particles.global_position = $Sprites.global_position
	death_particles.set_texture_and_material(death_texture, material)
	get_parent().add_child(death_particles)
	queue_free()
