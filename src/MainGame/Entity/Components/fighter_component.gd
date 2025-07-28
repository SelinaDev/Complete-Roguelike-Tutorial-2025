class_name FighterComponent
extends Component


@export var power: int


func process_message_precalculate(message: Message) -> void:
	match message.type:
		"prepare_hit":
			message.get_calculation("damage").base_value = power


func get_component_type() -> Type:
	return Type.Fighter
