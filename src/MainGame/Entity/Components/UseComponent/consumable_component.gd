class_name ConsumableUseComponent
extends UsableComponent

@export var uses: int = 1

func activate(user: Entity, targets: Array[Entity]) -> bool:
	var did_activate := super.activate(user, targets)
	if did_activate:
		consume(user)
	return did_activate


func consume(user: Entity) -> void:
	uses -= 1
	if uses <= 0:
		var user_inventory: InventoryComponent = user.get_component(Component.Type.Inventory)
		if user_inventory:
			user_inventory.items.erase(_parent_entity)
		elif _parent_entity.map_data != null:
			_parent_entity.map_data.remove_entity(_parent_entity)
