class_name PlayerActorComponent
extends ActorComponent


func _enter_entity() -> void:
	InputStack.register_input_callback(_on_event)


func before_exit() -> void:
	InputStack.pop_stack()


func _on_event(event: InputEvent) -> void:
	if event.is_released():
		return
	
	if event.is_action_pressed("zoom_in"):
		_parent_entity.process_message(Message.new("zoom_in"))
	if event.is_action_pressed("zoom_out"):
		_parent_entity.process_message(Message.new("zoom_out"))
	
	
	var move_offset := Vector2i.ZERO
	
	if event.is_action("move_left"):
		move_offset += Vector2i.LEFT
	elif event.is_action("move_right"):
		move_offset += Vector2i.RIGHT
	elif event.is_action("move_up"):
		move_offset += Vector2i.UP
	elif event.is_action("move_down"):
		move_offset += Vector2i.DOWN
	
	if move_offset != Vector2i.ZERO:
		_queued_action = MovementAction.new(_parent_entity, move_offset.x, move_offset.y)
