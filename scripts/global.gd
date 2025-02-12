extends Node

var Greg

var checkpoints = []
var saved_position = Vector2()

var collected_upgrades = []
var upgrades = []
var upgrades_position = []
var upgrades_keybinds = [KEY_1]

func shake_screen(x):
	Greg.get_node('Camera2D').shake(x)

func fade_in():
	pass

func fade_out():
	pass

func respawn():
	print('sup')
	var game = get_node('../Game')
	await fade_out()
	game.remove_child(game.get_child(0))
	var level = load('res://scenes/worldtest.tscn').instantiate()
	level.add_child(load("res://scenes/greg.tscn").instantiate())
	game.add_child(level)
	await fade_in()
