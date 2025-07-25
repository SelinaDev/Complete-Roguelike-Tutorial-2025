class_name MapData
extends Resource

signal entity_sprite_spawned(entity_sprite)

var _TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")

@export_storage var entities: Array[Entity]
@export_storage var tiles: Dictionary[Vector2i, Tile]
@export_storage var size: Vector2i

var _fov: Dictionary[Vector2i, bool] = {}


func spawn_entity_at(entity: Entity, position: Vector2i) -> void:
	entity.place_at(position, self)
	entities.append(entity)
	draw_entity(entity)
	entity.process_message(Message.new("map_entered"))


func remove_entity(entity: Entity) -> void:
	entities.erase(entity)
	entity.map_data = null
	entity.remove_component(Component.Type.Position)


func draw_entities() -> void:
	for entity: Entity in entities:
		draw_entity(entity)


func get_tile_sprites() -> Array:
	return tiles.values().map(func(t: Tile) -> Sprite2D: return t.get_sprite())


func draw_entity(entity: Entity) -> void:
	var drawable_component: DrawableComponent = entity.get_component(Component.Type.Drawable) as DrawableComponent
	if drawable_component:
		entity_sprite_spawned.emit(drawable_component.get_sprite())
	else:
		push_warning("Tried drawing non-drawable entity '%s'" % entity.name)


func get_entities_with_components(component_types: Array[Component.Type]) -> Array[Entity]:
	return entities.filter(
		func(e: Entity) -> bool:
			return component_types.all(
				func(t: Component.Type) -> bool:
					return e.has_component(t)
			)
	)


func set_tile(tile_position: Vector2i, tile_template: TileTemplate) -> Tile:
	if not Rect2i(Vector2i.ZERO, size).has_point(tile_position):
		return null
	var tile := Tile.new(tile_template, tile_position)
	tiles[tile_position] = tile
	return tile


func set_fov(new_fov: Dictionary[Vector2i, bool]) -> void:
	for position: Vector2i in _fov:
		tiles.get(position).is_in_view = false
	_fov = new_fov
	for position: Vector2i in _fov:
		tiles.get(position).is_in_view = true
	for entity: Entity in entities:
		entity.process_message(Message.new("fov_update").with_data({"fov": _fov}))


func is_in_fov(position: Vector2i) -> bool:
	return _fov.get(position, false)


func world_to_grid(world_position: Vector2) -> Vector2i:
	return Vector2i(world_position / _TILE_SIZE)


func grid_to_world(grid_position: Vector2i) -> Vector2:
	return Vector2(grid_position) * _TILE_SIZE
