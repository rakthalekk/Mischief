class_name Smalls
extends Rat

signal sqek

var on_push_block = false
var stupid_sound_counter = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("action") && !climbing && active:
		$Sqek.play()
		emit_signal("sqek")
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get_name() == "Dull_Spikes":
			emit_signal("die")
		if collision.collider.get_name() == "Pushables":
			on_push_block = true
		else:
			on_push_block = false
		if next_to_climbing_wall(0) && !is_on_floor():
			climbing = true
			_velocity.y = 0
		else:
			climbing = false
		if collision.collider.get_name() == "GoalBlock" and is_on_floor():
			emit_signal("on_goal")
	if climbing:
		if active:
			handle_climbing(delta)
		if get_slide_count() == 0:
			climbing = false
		
		
func handle_climbing(_delta):
	var y_offset = (Input.get_action_strength("climb_down") - Input.get_action_strength("climb_up")) * 5
	# Does not climb if Smalls would no longer be next to the wall
	if(next_to_climbing_wall(y_offset)):
		translate(Vector2(0, (y_offset)))
	if Input.is_action_just_pressed("action"):
		climbing = false
		_velocity.y = 5
	if Input.is_action_just_pressed("jump"):
		climbing = false
		_velocity.y -= 850


#Returns whether there is an adjacent climbing wall
func next_to_climbing_wall(y_offset):
	var climbable_tilemap = $"../SubTiles/Climbable"
	return climbable_tilemap.get_cellv(climbable_tilemap.world_to_map(position + Vector2(-sprite.scale.x*60, y_offset))) == 0
