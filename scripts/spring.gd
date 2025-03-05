@tool
extends Sprite2D

@export var to: Node2D

func _process(_delta):
	if not to: return
	global_rotation = global_position.angle_to_point(to.global_position) - PI/2 
	scale.y = $"..".global_scale.x * global_position.distance_to(to.global_position)/texture.region.size.y* sign( to.global_position.x - global_position.x)
