class_name ActionWithDirection
extends Action

var offset: Vector2i


func _init(entity: Entity, dx: int, dy: int) -> void:
	super._init(entity)
	offset = Vector2i(dx, dy)


func get_destination() -> Vector2i:
	var destination := offset
	var position_component: PositionComponent = _performing_entity.get_component(Component.Type.Position)
	if not position_component:
		push_error("Tried to get destination for entity '%s' without Position Component" % _performing_entity.name)
	destination += position_component.position
	return destination
