extends Node2D
class_name GunPart

@export var height: float
@export var damage: int = 1
var wielder
var is_enemy: bool

func set_wielder(to):
	wielder = to
	is_enemy = wielder.is_in_group('enemies')

func hit(target: Node) -> void:
	if target is not Damageable: return
	if target.is_in_group('enemies') == is_enemy: return
	target.damage(damage)
