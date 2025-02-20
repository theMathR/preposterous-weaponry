extends Node

var Greg

var checkpoints = []
var saved_position = Vector2()

var saved_collected_upgrades = []
var saved_upgrades = []
var saved_upgrades_position = []

var collected_upgrades = []
var upgrades = []
var upgrades_position = []

func shake_screen(x):
	Greg.get_node('Camera2D').shake(x)

func respawn():
	get_tree().change_scene_to_file("res://game.tscn")
