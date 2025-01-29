@tool
extends Sprite2D

@export var to: Node2D

func _process(delta):
	global_rotation = global_position.angle_to_point(to.global_position) - PI/2 
	scale.y = global_position.distance_to(to.global_position)/texture.region.size.y * $"../..".scale.x
