class_name Bar
extends MarginContainer

@export var stat_name: String
@export var full_color: Color
@export var empty_color: Color

@onready var label: Label = $Label
@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	var fill_box := StyleBoxFlat.new()
	fill_box.bg_color = full_color
	progress_bar.set("theme_override_styles/fill", fill_box)
	
	var background_box := StyleBoxFlat.new()
	background_box.bg_color = empty_color
	progress_bar.set("theme_override_styles/background", background_box)


func set_values(value: int, max_value: int) -> void:
	progress_bar.max_value = max_value
	progress_bar.value = value
	label.text = "%s: %d/%d" % [stat_name, value, max_value]
