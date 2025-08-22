class_name World
extends Node2D

signal map_data_set(map_data)


func _on_map_map_data_set(map_data: MapData) -> void:
	map_data_set.emit(map_data)
