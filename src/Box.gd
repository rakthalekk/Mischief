class_name Box
extends Actor

func _physics_process(_delta):
	var direction = Vector2(0, 0)
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	
	if $RayCastLeft.is_colliding() && $RayCastLeft.get_collider() is Actor:
		#translate(Vector2(4, 0))
		var collider = $RayCastLeft.get_collider()
		if(collider._velocity.x >= 0):
			_velocity.x = collider._velocity.x
	elif $RayCastRight.is_colliding() && $RayCastRight.get_collider() is Actor:
		#translate(Vector2(-4, 0))
		var collider = $RayCastRight.get_collider()
		if(collider._velocity.x <= 0):
			_velocity.x = collider._velocity.x
	else:
		_velocity.x = 0
			
	if $RayCastDown.is_colliding():
		_velocity.y = 0
	if !is_on_floor():
		_velocity.x = 0
		
	var _belocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)
	_velocity.y = _belocity.y
