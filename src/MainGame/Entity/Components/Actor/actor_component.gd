class_name ActorComponent
extends Component

var _queued_action: Action = null


func get_action() -> Action:
	var next_action: Action = _queued_action
	_queued_action = null
	return next_action


func process_message_execute(message: Message) -> void:
	match message.type:
		"died":
			_parent_entity.remove_component(type)


func get_component_type() -> Type:
	return Type.Actor
