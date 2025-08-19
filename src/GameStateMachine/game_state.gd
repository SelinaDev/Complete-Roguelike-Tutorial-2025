class_name GameState
extends Control

const SAVE_PATH = "user://save_game.tres"

signal transition_requested(new_state_path, data)


func enter(_data: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass
