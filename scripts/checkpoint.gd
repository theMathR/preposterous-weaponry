extends Area2D

@export var id: int
var checked = false

func _ready() -> void:
	checked = id in Global.checkpoints

func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Greg':
		$AnimationTree['parameters/shine/request'] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		$AnimationTree['parameters/state/playback'].travel('checked')
		Global.checkpoints.append(id)
		Global.saved_position = global_position + Vector2(0,-30)
		checked = true
		body.hp = body.max_hp
