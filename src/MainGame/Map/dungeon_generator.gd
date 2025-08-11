class_name DungeonGenerator
extends RefCounted

const RESOURCE_COLLECTION = preload("res://resources/ResourceCollection.tres")

var _settings: DungeonSettings
var _map_data: MapData
var _rng := RandomNumberGenerator.new()


func _init(settings: DungeonSettings = DungeonSettings.new()) -> void:
	_settings = settings


func generate_dungeon(player: Entity) -> MapData:
	_rng.randomize()
	_map_data = MapData.new()
	_map_data.player_entity = player
	_map_data.size = Vector2i(_settings.map_width, _settings.map_height)
	for x: int in _settings.map_width:
		for y: int in _settings.map_height:
			_map_data.set_tile(Vector2i(x, y), RESOURCE_COLLECTION.tiles["wall"])
	
	var rooms: Array[Rect2i] = []
	
	for _try_room in _settings.max_rooms:
		var room_width: int = _rng.randi_range(_settings.room_min_size, _settings.room_max_size)
		var room_height: int = _rng.randi_range(_settings.room_min_size, _settings.room_max_size)
		
		var x: int = _rng.randi_range(0, _map_data.size.x - room_width - 1)
		var y: int = _rng.randi_range(0, _map_data.size.y - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		if rooms.any(func(r: Rect2i) -> bool: return new_room.intersects(r)):
			continue
		
		_carve_room(new_room)
		
		if rooms.is_empty():
			_map_data.spawn_entity_at(player, new_room.get_center())
		else:
			_tunnel_between(rooms.back().get_center(), new_room.get_center())
			_place_entities(new_room)
		
		rooms.append(new_room)
	
	player.process_message(Message.new("recalculate_fov"))
	
	_map_data.setup_pathfinder()
	
	return _map_data


func _carve_tile(x: int, y: int) -> void:
	_map_data.set_tile(Vector2i(x, y), RESOURCE_COLLECTION.tiles["floor"])


func _carve_room(room: Rect2i) -> void:
	for x: int in range(room.position.x + 1, room.end.x):
		for y: int in range(room.position.y + 1, room.end.y):
			_carve_tile(x, y)


func _tunnel_horizontal(y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		_carve_tile(x, y)


func _tunnel_vertical(x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_carve_tile(x, y)


func _tunnel_between(start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(start.y, start.x, end.x)
		_tunnel_vertical(end.x, start.y, end.y)
	else:
		_tunnel_vertical(start.x, start.y, end.y)
		_tunnel_horizontal(end.y, start.x, end.x)


func _place_entities_weighted(room: Rect2i, amount: int, weights: Dictionary[String, float]) -> void:
	for _i in amount:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)
		
		var can_place: bool = _map_data.get_entities_at_position(new_entity_position).is_empty()
		if not can_place:
			continue
		
		var entity_key: String = weights.keys()[_rng.rand_weighted(weights.values())]
		var entity = RESOURCE_COLLECTION.entities[entity_key].reify()
		_map_data.spawn_entity_at(entity, new_entity_position)


func _place_entities(room: Rect2i) -> void:
	var num_monsters: int = _rng.randi_range(0, _settings.max_monsters_per_room)
	_place_entities_weighted(room, num_monsters, {
		"orc": 0.8,
		"troll": 0.2
	})
	
	var num_items: int = _rng.randi_range(0, _settings.max_items_per_room)
	_place_entities_weighted(room, num_items, {
		"healing_potion": 0.7,
		"lightning_scroll": 0.1,
		"fireball_scroll": 0.1,
		"confusion_scroll": 0.1,
	})
