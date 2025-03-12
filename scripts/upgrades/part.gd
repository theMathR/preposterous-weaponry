extends Node2D
class_name GunPart

@export var height: float
@export var damage: float = 1
var wielder
var shooting

func hit(target: Node) -> void:
	if target is not Damageable: return
	if target.is_in_group('enemies') == wielder.is_in_group('enemies'): return
	target.damage(damage)

func shoot():
	shooting = true
func release():
	shooting = false

func deploy():
	hide()
	$AnimationTree['parameters/conditions/deploy'] = true

func knock_back(x := 1):
	wielder.knockback += x
