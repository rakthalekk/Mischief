class_name Actor
extends KinematicBody2D

export var speed = Vector2(300.0, 750.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP
const FLOOR_DETECT_DISTANCE = 20.0

var _velocity = Vector2.ZERO
var dashing = false
var climbing = false

func _physics_process(delta):
	if !dashing and !climbing:
		_velocity.y += gravity * delta
