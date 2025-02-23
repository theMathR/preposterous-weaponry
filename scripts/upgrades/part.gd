extends Node2D
class_name GunPart

@export var height: float
@export var damage: int = 1
var wielder

func hit(target: Node) -> void:
	if target is not Damageable: return
	if target.is_in_group('enemies') == wielder.is_in_group('enemies'): return
	target.damage(damage)

func shoot() -> void: pass
func release() -> void: pass

func deploy():
	hide()
	$AnimationPlayer.play('deploy')

func knock_back(x := 1):
	wielder.knockback += x
