class_name Crombo
extends Actor

var target = null

onready var sprite = $Sprite

func _physics_process(_delta):
	if target:
		if target.position.x < position.x:
			_velocity.x = -1 * speed.x
			sprite.scale.x = 1
		elif target.position.x > position.x:
			_velocity.x = 1 * speed.x
			sprite.scale.x = -1
		else:
			_velocity.x = 0
	else:
		_velocity.x = 0
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider
		if collider is Rat:
			collider.emit_signal("die")
			target = null
	var direction = Vector2(0, 0)
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
		
	var _belocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)
	_velocity.y = _belocity.y

func _on_SightRange_body_entered(body):
	if (target and body.position.x - position.x < target.position.x - position.x) or !target:
		target = body


func _on_SightRange_body_exited(body):
	if body == target:
		target = null


func _on_Smalls_sqek():
	target = $"../Smalls"
