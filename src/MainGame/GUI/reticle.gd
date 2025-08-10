class_name Reticle
extends TileMapLayer

const TILE_SOURCE = 0
const TILE_ID = Vector2i(36, 12)

const LOOK_INFO_CONTAINER = preload("res://src/MainGame/GUI/InfoContainers/look_info_container.tscn")

var _camera_state: CameraState
var _map_data: MapData
var _info_callback: Callable = func() -> void: pass
var _info_container: InfoContainer
var _radius: int
var _grid_position: Vector2i:
	set(value):
		_grid_position = value
		_update()


func _ready() -> void:
	SignalBus.reticle_requested.connect(activate)


func activate(config: ReticleConfig) -> void:
	show()
	_camera_state = CameraStateStack.get_new_state()
	InputStack.register_input_callback(on_event)
	_map_data = config.map_data
	match config.info:
		ReticleConfig.Info.Look:
			_info_container = LOOK_INFO_CONTAINER.instantiate()
			_info_callback = _update_look_info
		_:
			_info_callback = func(): pass
	if _info_container:
		SignalBus.spawn_info_container.emit(_info_container)
	
	_radius = config.radius
	_grid_position = config.initial_position
	_camera_state.grid_position = _grid_position


func deactivate(get_targets: bool) -> void:
	hide()
	clear()
	InputStack.pop_stack()
	CameraStateStack.pop_state()
	_camera_state = null
	if _info_container:
		_info_container.close()
		_info_container = null
	var targets: Array[Entity] = []
	if get_targets:
		targets = _map_data.entities.filter(
			func(e: Entity) -> bool:
				return (e.get_component(Component.Type.Position) as PositionComponent).distance_to(_grid_position) <= _radius
		)
	SignalBus.reticle_targets_selected.emit(targets)


func _update() -> void:
	clear()
	_camera_state.grid_position = _grid_position
	var tiles: Array[Vector2i] = []
	for x: int in range(_grid_position.x - _radius, _grid_position.x + _radius + 1):
		for y: int in range(_grid_position.y - _radius, _grid_position.y + _radius + 1):
			tiles.append(Vector2i(x, y))
	_set_tiles(tiles)
	_info_callback.call()


func _update_look_info() -> void:
	var tile: Tile = _map_data.tiles.get(_grid_position)
	var entities: Array[Entity] = _map_data.get_entities_at_position(_grid_position)
	(_info_container as LookInfoContainer).set_look_info(tile, entities)


func _set_tiles(positions: Array[Vector2i]) -> void:
	for p: Vector2i in positions:
		set_cell(p, TILE_SOURCE, TILE_ID)


func on_event(event: InputEvent) -> void:
	if event.is_released():
		return
	
	if event.is_action("move_up"):
		_grid_position += Vector2i.UP
	elif event.is_action("move_down"):
		_grid_position += Vector2i.DOWN
	elif event.is_action("move_left"):
		_grid_position += Vector2i.LEFT
	elif event.is_action("move_right"):
		_grid_position += Vector2i.RIGHT
	elif event.is_action("move_up_left"):
		_grid_position += Vector2i.UP + Vector2i.LEFT
	elif event.is_action("move_up_right"):
		_grid_position += Vector2i.UP + Vector2i.RIGHT
	elif event.is_action("move_down_left"):
		_grid_position += Vector2i.DOWN + Vector2i.LEFT
	elif event.is_action("move_down_right"):
		_grid_position += Vector2i.DOWN + Vector2i.RIGHT
	elif event.is_action_pressed("zoom_in"):
		_camera_state.zoom += 1
	elif event.is_action_pressed("zoom_out"):
		_camera_state.zoom -= 1
	
	elif event.is_action_pressed("ui_cancel"):
		deactivate(false)
	elif event.is_action_pressed("ui_accept"):
		deactivate(true)
