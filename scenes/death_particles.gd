extends GPUParticles2D

func _ready() -> void:
	restart()

func set_texture_and_material(new_texture, new_material):
	$SubViewport/Sprite2D.material = new_material
	$SubViewport/Sprite2D.texture = new_texture

func _on_finished() -> void:
	queue_free()
