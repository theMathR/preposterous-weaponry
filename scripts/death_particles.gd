extends Sprite2D

var velocity: Vector2

func set_texture_and_material(new_texture, new_material):
	material = new_material
	texture = new_texture
	velocity.x = randf_range(-50,50)
	velocity.y = -5000

func _process(delta: float) -> void:
	position += velocity * delta
	if velocity.y<100000: velocity.y += 18000 * delta
	if Global.Greg.global_position.y - global_position.y < -1500:
		queue_free()
