extends Area2D

@export var texture: Texture2D
@export var upgrade: PackedScene
var going_to_player = false

func _ready():
	$Sprite2D.texture = texture

func _process(delta):
	$Background.rotation += delta
	
	if not going_to_player: return
	global_position -= (global_position - Global.Greg.global_position).normalized() * delta * 5000
	if global_position.distance_squared_to(Global.Greg.global_position) < 25000000 * delta * delta:
		queue_free()
		Global.Greg.acquire_upgrade(upgrade)
		Global.Greg.set_face(4)

func _on_body_entered(body):
	if body == Global.Greg:
		$AnimationPlayer.play("collect")
		$AudioStreamPlayer.play()
		collision_mask = 0


func _on_animation_player_animation_finished(_anim_name):
	global_position = $Sprite2D.global_position
	$Sprite2D.position *= 0
	going_to_player = true
