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
		
	if event.is_action_pressed("look"):
		var position := PositionComponent.get_entity_position(_parent_entity)
		var reticle_config := ReticleConfig.new(_parent_entity.map_data, position).with_info(ReticleConfig.Info.Look)
		SignalBus.reticle_requested.emit(reticle_config)
	
	
	var move_offset := Vector2i.ZERO
	
	if event.is_action("move_left"):
		move_offset += Vector2i.LEFT
	elif event.is_action("move_right"):
		move_offset += Vector2i.RIGHT
	elif event.is_action("move_up"):
		move_offset += Vector2i.UP
	elif event.is_action("move_down"):
		move_offset += Vector2i.DOWN
	elif event.is_action("move_up_left"):
		move_offset += Vector2i.UP + Vector2i.LEFT
	elif event.is_action("move_up_right"):
		move_offset += Vector2i.UP + Vector2i.RIGHT
	elif event.is_action("move_down_left"):
		move_offset += Vector2i.DOWN + Vector2i.LEFT
	elif event.is_action("move_down_right"):
		move_offset += Vector2i.DOWN + Vector2i.RIGHT
	
	if move_offset != Vector2i.ZERO:
		_queued_action = BumpAction.new(_parent_entity, move_offset)
	
	if event.is_action("wait"):
		_queued_action = WaitAction.new(_parent_entity)
