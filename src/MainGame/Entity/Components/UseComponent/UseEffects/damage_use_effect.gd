class_name DamageUseEffect
extends UseEffect

@export var amount: int
@export var verb: String = "damaged"


func apply(entity: Entity, source: Entity) -> bool:
	var damage_message := Message.new("take_damage").with_data({
		"source": source,
		"verb": verb,
	})
	damage_message.get_calculation("damage").base_value = amount
	entity.process_message(damage_message)
	return true
