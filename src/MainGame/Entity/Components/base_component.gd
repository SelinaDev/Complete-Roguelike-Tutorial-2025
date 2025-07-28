class_name Component
extends Resource

enum Type {
	None,
	Actor,
	Camera,
	Drawable,
	Durability,
	Fighter,
	FOV,
	MovementBlocker,
	Player,
	Position,
}

var _parent_entity: Entity:
	set(value):
		_parent_entity_ref = weakref(value)
	get:
		return _parent_entity_ref.get_ref() as Entity
var _parent_entity_ref: WeakRef = weakref(null)
var type: Type: get = get_component_type


func get_component_type() -> Type:
	push_error("get_component_type() not properly implemented, called abstract base function!")
	return Type.None


func _enter_entity() -> void:
	pass


func enter_entity(entity: Entity) -> void:
	_parent_entity = entity
	_enter_entity()


func before_exit() -> void:
	pass


func process_message_precalculate(_message: Message) -> void:
	pass


func process_message_execute(_message: Message) -> void:
	pass
