class_name TurnQueue
extends Node

var _map_data: MapData
var _queue: Array[Entity] = []
var _i: int = 0


func _ready() -> void:
	set_process(false)


func start(map_data: MapData) -> void:
	_map_data = map_data
	_i = 0
	_queue.clear()
	set_process(true)


func stop() -> void:
	_map_data = null
	_queue = []
	set_process(false)


func _process(_delta: float) -> void:
	if _i >= _queue.size():
		_rebuild_queue()
	while _i < _queue.size():
		var current_actor: ActorComponent = _queue[_i].get_component(Component.Type.Actor)
		if not current_actor:
			_i += 1
			continue
		var action: Action = current_actor.get_action()
		if not action:
			return
		var result := await action.perform()
		if result or not _queue[_i].has_component(Component.Type.Player):
			_queue[_i].process_message(Message.new("turn_end"))
			_i += 1


func _rebuild_queue() -> void:
	_queue = _map_data.get_entities_with_components([Component.Type.Actor])
	_i = 0
