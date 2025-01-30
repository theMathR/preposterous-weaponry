class_name Enemy
extends CharacterBody2D

@export var hp: int = 3

func damage(dmg: int):
	hp -= dmg
	if hp <= 0: queue_free()
