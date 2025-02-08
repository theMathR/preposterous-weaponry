extends GunPart

@export var doing_damage = false
var punching = true

func shoot():
	punching = true
func release():
	punching = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (doing_damage and body is Damageable): return
	body.damage(damage)
	body.velocity.x += 500 * global_scale
	body.velocity.y -= 100
