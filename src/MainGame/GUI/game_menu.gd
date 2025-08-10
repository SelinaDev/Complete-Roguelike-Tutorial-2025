class_name GameMenu
extends MarginContainer

signal option_selected(index)

@onready var _background: ColorRect = %Background
@onready var _title_label: Label = %TitleLabel
@onready var _action_prompt_label: Label = %ActionPromptLabel
@onready var _button_list: VBoxContainer = %ButtonList


func setup(title: String, options: Array) -> GameMenu:
	InputStack.register_input_callback(_on_event)
	_title_label.text = title
	for i: int in options.size():
		_add_button(options[i], i)
	if not options.is_empty():
		_button_list.get_child(0).grab_focus()
	return self


func _on_event(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		_on_button_pressed(-1)


func with_prompt(action_prompt: String) -> GameMenu:
	_action_prompt_label.show()
	_action_prompt_label.text = action_prompt
	return self


func with_bg_color(color: Color) -> GameMenu:
	_background.color = color
	return self


func _add_button(text: String, index: int) -> void:
	if index >= 26:
		push_error("Index above 26 in menu")
	var button := Button.new()
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	button.clip_text = true
	button.text = String.chr("a".unicode_at(0) + index) + ") " + text
	var shortcut_event := InputEventKey.new()
	shortcut_event.keycode = KEY_A + index
	button.shortcut = Shortcut.new()
	button.shortcut.events = [shortcut_event]
	button.pressed.connect(_on_button_pressed.bind(index))
	_button_list.add_child(button)


func _on_button_pressed(index: int) -> void:
	InputStack.pop_stack()
	queue_free()
	option_selected.emit(index)
