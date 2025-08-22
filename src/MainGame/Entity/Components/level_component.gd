class_name LevelComponent
extends Component

signal level_changed(new_level)
signal xp_changed(xp_current, xp_to_next)

@export_storage var current_level: int = 1:
	set(value):
		current_level = value
		level_changed.emit(current_level)
@export_storage var current_xp: int = 0:
	set(value):
		current_xp = value
		xp_changed.emit(current_xp, experience_to_next_level())
@export var level_up_base: int = 0
@export var level_up_factor: int = 150


func experience_to_next_level() -> int:
	return level_up_base + current_level * level_up_factor


func process_message_execute(message: Message) -> void:
	match message.type:
		"xp_received":
			var xp: int = message.get_calculation("xp").get_result()
			if xp >= 0:
				add_xp(xp)
		"level_up":
			increase_level()


func requires_level_up() -> bool:
	return current_xp > experience_to_next_level()


func add_xp(xp: int) -> void:
	if xp == 0 or level_up_base == 0:
		return
	
	current_xp += xp
	
	Log.send_log("You gain %d experience points." % xp, Log.COLOR_POSITIVE)
	
	_check_level_up()


func increase_level() -> void:
	current_xp -= experience_to_next_level()
	current_level += 1
	current_xp = current_xp
	await _handle_level_up_menu()
	_check_level_up()


func _check_level_up() -> void:
	if requires_level_up():
		Log.send_log("You advance to level %d!" % (current_level + 1), Log.COLOR_POSITIVE)
		_parent_entity.process_message(Message.new("level_up"))


func _handle_level_up_menu() -> void:
	pass

func get_component_type() -> Type:
	return Type.Level
