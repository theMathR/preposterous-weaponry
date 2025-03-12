extends GunPart

@export var dps = 5
@export var damaging = false


func _physics_process(delta: float) -> void:
	if not damaging: return
	damage = dps * delta
	for body in $Area2D.get_overlapping_bodies():
		print(body.name, damage)
		hit(body)
