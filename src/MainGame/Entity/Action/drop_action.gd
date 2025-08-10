class_name DropAction
extends ItemAction


func perform() -> bool:
	var message := Message.new("drop_item").with_data({"item": _item})
	_performing_entity.process_message(message)
	return message.flags.get("did_drop_item", false)
