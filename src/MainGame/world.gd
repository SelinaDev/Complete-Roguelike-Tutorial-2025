class_name World
extends Node2D

signal player_set(player_entity)


func _on_map_map_data_set(map_data: MapData) -> void:
	player_set.emit(map_data.player_entity)
