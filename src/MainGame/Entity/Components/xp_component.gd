class_name XpComponent
extends Component

@export var xp: int


func process_message_execute(message: Message) -> void:
	match message.type:
		"died":
			var source: Entity = message.data.get("source")
			if source:
				var xp_message := Message.new("xp_received")
				xp_message.get_calculation("xp").base_value = xp
				source.process_message(xp_message)


func get_component_type() -> Type:
	return Type.XP
