class_name ToggleEquipmentAction
extends ItemAction


func perform() -> bool:
	if not _item.has_component(Component.Type.Equippable):
		Log.send_log("%s cannot be equipped." % _item.get_entity_name(), Log.COLOR_IMPOSSIBLE)
	var equip_message := Message.new("equip_item").with_data({"item": _item})
	_performing_entity.process_message(equip_message)
	return equip_message.flags.get("did_equip", false)
