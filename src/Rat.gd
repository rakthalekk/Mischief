class_name Rat
extends Actor

signal switch_rats
signal die
signal on_goal
signal checkpoint
signal win

var active = true setget set_active
var on_goal = false
var on_win = false

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

func _physics_process(_delta):
	var direction = get_direction() if active else Vector2.ZERO

	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	if !dashing:
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var _belocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)
	_velocity.y = _belocity.y

	if direction.x != 0:
		sprite.scale.x = -1 if direction.x > 0 else 1
	var animation = get_new_animation()
	animation_player.play(animation)
	
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider.get_name()
		if collider == "Spiky_Spikes" || collider == "Inner_Spikes":
			emit_signal("die")
		if collider == "GoalBlock" and is_on_floor():
			on_goal = true
		else:
			on_goal = false
		if collider == "Checkpoints" and is_on_floor():
			emit_signal("checkpoint")
		if collider == "WinBlock" and is_on_floor():
			on_win = true
			emit_signal("win")
		else:
			on_win = false
		if collider == "Crombo":
			emit_signal("die")
	if Input.is_action_just_pressed("switch") and active:
		yield(get_tree().create_timer(0.001), "timeout") # Prevents immediate swap between rats
		emit_signal("switch_rats")
		active = false
	if Input.is_action_just_pressed("reset_stage") and active:
		Global.go_next_stage(Global.current_scene);


func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left") if !climbing else 0,
		-1 if (is_on_floor()) and Input.is_action_just_pressed("jump") else 0
	)


func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y *= 0.5
	return velocity


func get_new_animation():
	if climbing:
		sprite.rotation_degrees = 90 * sprite.scale.x
		return "climbing"
	sprite.rotation_degrees = 0
	var animation_new = ""
	if dashing:
		animation_new = "dashing"
	elif is_on_floor():
		animation_new = "running" if abs(_velocity.x) > 0.1 else "idle"
	else:
		animation_new = "jumping"
	return animation_new

func set_active(b: bool):
	active = b
