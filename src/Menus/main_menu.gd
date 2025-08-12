extends GameState

@export_file("*.tscn") var game_scene

@onready var load_game_button: Button = %LoadGameButton


func _ready() -> void:
	load_game_button.disabled = FileAccess.file_exists(SAVE_PATH)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_game_button_pressed(load_game: bool) -> void:
	transition_requested.emit(game_scene, {"load_game": load_game})
