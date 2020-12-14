extends Node

var current_scene = 1

func go_next_stage(scene = current_scene + 1):
	current_scene = scene
	get_tree().change_scene("res://src/Level"+str(current_scene)+".tscn")
