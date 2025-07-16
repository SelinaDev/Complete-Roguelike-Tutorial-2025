extends Sprite2D

var TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")


func _ready() -> void:
	InputStack.register_input_callback(player_input)


func player_input(event: InputEvent) -> void:
	var move_dir := Vector2.ZERO
	
	# Don't want to do anything on key up
	if event.is_released():
		return
	
	if event.is_action("move_left"):
		move_dir += Vector2.LEFT
	elif event.is_action("move_right"):
		move_dir += Vector2.RIGHT
	elif event.is_action("move_up"):
		move_dir += Vector2.UP
	elif event.is_action("move_down"):
		move_dir += Vector2.DOWN
	
	position += move_dir * TILE_SIZE
