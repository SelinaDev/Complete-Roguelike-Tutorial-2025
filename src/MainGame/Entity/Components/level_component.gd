class_name LevelComponent
extends Component

enum LevelUpOption {
	Health,
	Power,
	Defense,
}

const LevelUpOptionText = {
	LevelUpOption.Health: "Increase Max HP (+20)",
	LevelUpOption.Power: "Increase Power (+1)",
	LevelUpOption.Defense: "Increase Defense (+1)",
}

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
@export var level_up_base: int = 200
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
	var level_up_options := [LevelUpOption.Health, LevelUpOption.Power, LevelUpOption.Defense]
	var level_up_option_texts: Array = level_up_options.map(func(l: LevelUpOption) -> String: return LevelUpOptionText[l])
	var level_up_index: int = -1
	while level_up_index < 0 or level_up_index >= level_up_options.size():
		var level_up_menu: GameMenu = MainGame.spawn_game_menu("Level Up", level_up_option_texts, true)
		level_up_index = await level_up_menu.option_selected
	match level_up_options[level_up_index]:
		LevelUpOption.Health:
			var message := Message.new("increase_max_hp")
			message.get_calculation("amount").base_value = 20
			_parent_entity.process_message(message)
			Log.send_log("You feel healthier.", Log.COLOR_POSITIVE)
		LevelUpOption.Power:
			var message := Message.new("increase_power")
			message.get_calculation("amount").base_value = 1
			_parent_entity.process_message(message)
			Log.send_log("You feel stronger.", Log.COLOR_POSITIVE)
		LevelUpOption.Defense:
			var message := Message.new("increase_defense")
			message.get_calculation("amount").base_value = 1
			_parent_entity.process_message(message)
			Log.send_log("You feel more durable.", Log.COLOR_POSITIVE)


func get_component_type() -> Type:
	return Type.Level
