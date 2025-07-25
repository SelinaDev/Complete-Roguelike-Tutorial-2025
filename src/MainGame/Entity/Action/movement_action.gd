class_name MovementAction
extends ActionWithDirection


func perform() -> bool:
	var move_message := Message.new("move").with_data({"destination": get_destination()})
	_performing_entity.process_message(move_message)
	
	return _check_message_flag(move_message, "did_perform_move")
