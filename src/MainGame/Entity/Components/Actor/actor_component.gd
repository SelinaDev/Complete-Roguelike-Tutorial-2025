class_name ActorComponent
extends Component

var _queued_action: Action = null


func get_action() -> Action:
	var next_action: Action = _queued_action
	_queued_action = null
	return next_action


func get_component_type() -> Type:
	return Type.Actor
