extends GameState

@export_file("*.tscn") var game_scene

@onready var load_game_button: Button = %LoadGameButton
@onready var new_game_button: Button = %NewGameButton


func _ready() -> void:
	new_game_button.grab_focus()
	load_game_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	CameraStateStack.reset()
	InputStack.reset()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_game_button_pressed(load_game: bool) -> void:
	transition_requested.emit(game_scene, {"load_game": load_game})
