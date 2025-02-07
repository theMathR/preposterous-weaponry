extends Area2D

@export var texture: Texture2D
@export var upgrade: PackedScene
var going_to_player = false
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Background.rotation += delta
	if not going_to_player: return
	global_position += -(global_position - player.global_position).normalized() * delta * 5000
	if global_position.distance_squared_to(player.global_position) < 25000000 * delta * delta:
		queue_free()
		player.get_parent().acquire_upgrade(upgrade)

func _on_body_entered(body):
	if body.name == 'Greg':
		$AnimationPlayer.play("collect")
		player = body.get_node('Sprites')
		collision_mask = 0


func _on_animation_player_animation_finished(_anim_name):
	global_position = $Sprite2D.global_position
	$Sprite2D.position *= 0
	going_to_player = true
