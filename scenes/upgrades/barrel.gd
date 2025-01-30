extends Node2D

@export var damage: int = 1
@export var keybind = KEY_A
@onready var player = $"../../../.."


func _process(delta):
	if Input.is_key_pressed(keybind) and not $AnimationPlayer.is_playing():
		await get_tree().create_timer(randf_range(0.1,0.2)).timeout
		player.knockback += 1
		$AnimationPlayer.play("shoot")
		var hit = $RayCast2D.get_collider()
		if hit and is_instance_of(hit, Enemy):
			hit.damage(damage)
