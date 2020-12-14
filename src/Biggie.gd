class_name Biggie
extends Rat

const DASH_SPEED = Vector2(1000, 0)
const DASH_TIME = 0.25

var dash_timer = 0
var air_dash = false

func _ready():
	active = false

func _physics_process(delta):
	if active:
		if Input.is_action_just_pressed("action") && dash_timer == 0 && !air_dash:
			dash_timer = DASH_TIME
			_velocity.y = 0
			dashing = true
	if dash_timer > 0:
		handle_dash(delta)
	if is_on_floor():
		air_dash = false

func handle_dash(delta):
	_velocity = calculate_move_velocity(_velocity, Vector2(-sprite.scale.x, 0), DASH_SPEED, false)
	dash_timer -= delta
	if dash_timer <= 0:
		dash_timer = 0
		dashing = false
	if !is_on_floor():
		air_dash = true
	for i in get_slide_count():
		var foreground = $"../Foreground"
		var breakables = $"../SpecialTiles/Breakables"
		var pushables = $"../SpecialTiles/Pushables"
		var collision = get_slide_collision(i)
		if collision.collider.get_name() == "Breakables":
			if breakables.get_cellv(breakables.world_to_map(collision.position)) == 0:
				breakables.set_cellv(breakables.world_to_map(collision.position), -1)
			elif breakables.get_cellv(breakables.world_to_map(collision.position + Vector2(-60, 0))) == 0:
				breakables.set_cellv(breakables.world_to_map(collision.position + Vector2(-60, 0)), -1)
			dash_timer = 0.05
		elif collision.collider.get_name() == "Pushables":
			if pushables.get_cellv(pushables.world_to_map(collision.position)) == 0 \
					&& foreground.get_cellv(foreground.world_to_map(collision.position + Vector2(60, 0))) == -1:
				pushables.set_cellv(pushables.world_to_map(collision.position), -1)
				pushables.set_cellv(pushables.world_to_map(collision.position + Vector2(60, 0)), 0)
				if $"../Smalls".on_push_block && foreground.get_cellv(foreground.world_to_map(collision.position + Vector2(60, -60))) == -1:
					$"../Smalls".translate(Vector2(60, 0))
			elif pushables.get_cellv(pushables.world_to_map(collision.position + Vector2(-60, 0))) == 0 \
					&& foreground.get_cellv(foreground.world_to_map(collision.position + Vector2(-120, 0))) == -1:
				pushables.set_cellv(pushables.world_to_map(collision.position + Vector2(-60, 0)), -1)
				pushables.set_cellv(pushables.world_to_map(collision.position + Vector2(-120, 0)), 0)
				if $"../Smalls".on_push_block && foreground.get_cellv(foreground.world_to_map(collision.position + Vector2(-60, -60))) == -1:
					$"../Smalls".translate(Vector2(-60, 0))
			dash_timer = 0.05
