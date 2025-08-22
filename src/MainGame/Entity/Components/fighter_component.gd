class_name FighterComponent
extends Component


@export var power: int


func process_message_precalculate(message: Message) -> void:
	match message.type:
		"prepare_hit":
			message.get_calculation("damage").base_value = power


func process_message_execute(message: Message) -> void:
	match message.type:
		"increase_power":
			var amount: int = message.get_calculation("amount").get_result()
			power += amount
		"get_power":
			message.get_calculation("power").terms.append(power)



func get_component_type() -> Type:
	return Type.Fighter
