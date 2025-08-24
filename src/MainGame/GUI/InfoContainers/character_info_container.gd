class_name CharacterInfoContainer
extends InfoContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel


func setup(player: Entity) -> void:
	InputStack.register_input_callback(
		func(e: InputEvent) -> void:
			if e.is_action_pressed("ui_cancel"):
				InputStack.pop_stack()
				close()
	)
	
	var player_level: LevelComponent = player.get_component(Component.Type.Level)
	
	var power_message := Message.new("get_power")
	player.process_message(power_message)
	var defense_message := Message.new("get_desense")
	player.process_message(defense_message)
	
	var text := """
	[center]Level %d[/center]
	Power: %d
	Defense: %d
	""" % [
		player_level.current_level,
		power_message.get_calculation("power").get_result(),
		defense_message.get_calculation("defense").get_result()
	]
	
	rich_text_label.parse_bbcode(text)
