extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Greg':
		$AnimationTree['parameters/shine/request'] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
