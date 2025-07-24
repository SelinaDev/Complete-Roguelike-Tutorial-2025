class_name Map
extends Node2D

signal map_data_set(map_data)

@onready var tiles: Node2D = $Tiles
@onready var entities: Node2D = $Entities

const PLAYER = preload("res://resources/entities/player.tres")


var _map_data: MapData:
	set = set_map_data


func _ready() -> void:
	var FLOOR: TileTemplate = preload("res://resources/tiles/floor.tres")
	var WALL: TileTemplate = preload("res://resources/tiles/wall.tres")
	var map_data := MapData.new()
	for x: int in 80:
		for y: int in 50:
			var tile_position := Vector2i(x, y)
			var tile := Tile.new(FLOOR, tile_position)
			map_data.tiles[tile_position] = tile
	for y: int in range(5, 10):
		var tile_position := Vector2i(5, y)
		map_data.tiles[tile_position] = Tile.new(WALL, tile_position)
	set_map_data(map_data)
	_map_data.spawn_entity_at(PLAYER.reify(), Vector2i(2, 2))


func set_map_data(new_map_data: MapData) -> void:
	for tile_node: Node in tiles.get_children():
		tile_node.queue_free()
	for entity_node: Node in entities.get_children():
		entity_node.queue_free()
	_map_data = new_map_data
	_map_data.entity_sprite_spawned.connect(entities.add_child)
	_map_data.draw_entities()
	for tile_sprite: Node in _map_data.get_tile_sprites():
		tiles.add_child(tile_sprite)
	map_data_set.emit(new_map_data)
