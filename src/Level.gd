extends Node2D

export var LIMIT_LEFT = 0
export var LIMIT_TOP = 0
export var LIMIT_RIGHT = 3660
export var LIMIT_BOTTOM = 900
export var LEVEL_NUM = 1
onready var SMALLS_SPAWN = $Smalls.position
onready var BIGGIE_SPAWN = $Biggie.position
onready var checkpoints = $"SpecialTiles/Checkpoints"

func _ready():
	Global.current_scene = LEVEL_NUM
	for child in get_children():
		if child is Rat:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM


func _on_switch_rats():
	if($"Smalls".active):
		$"Biggie/Camera".current = true
		$Biggie.active = true
	else:
		$"Smalls/Camera".current = true
		$Smalls.active = true


func _on_Smalls_die():
	$Smalls.position = SMALLS_SPAWN


func _on_Biggie_die():
	$Biggie.position = BIGGIE_SPAWN
	$Biggie.dashing = false
	$Biggie.dash_timer = 0


func _on_on_goal():
	if $Biggie.on_goal and $Smalls.on_goal:
		Global.go_next_stage()


func _on_Smalls_checkpoint():
	if checkpoints.get_cellv(checkpoints.world_to_map($Smalls.position + Vector2(0, 60))) == 0:
		SMALLS_SPAWN = $Smalls.position


func _on_Biggie_checkpoint():
	if checkpoints.get_cellv(checkpoints.world_to_map($Biggie.position + Vector2(0, 60))) == 0:
		BIGGIE_SPAWN = $Biggie.position


func _on_win():
	if $Biggie.on_win and $Smalls.on_win:
		get_tree().quit()
