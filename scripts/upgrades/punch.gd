extends GunPart

@export var doing_damage = false

func shoot():
	if $AnimationPlayer.is_playing(): return
	$AnimationPlayer.play("attack")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (doing_damage and body is Damageable): return
	if body.is_in_group('enemies') == wielder.is_in_group('enemies'): return
	body.damage(damage)
	body.velocity += Vector2(5000,0).rotated(global_rotation)
	if body.velocity.length_squared() > 5000**2:
		body.velocity *= 5000/body.velocity.length()

func apply_punch():
	for body in $Area2D.get_overlapping_bodies():
		_on_area_2d_body_entered(body)

func deploy():
	hide()
	$AnimationPlayer.play('deploy')
