class_name DrawableComponent
extends Component

enum RenderOrder {
	MAP_OBJECT,
	CORPSE,
	ITEM,
	ACTOR
}

@export var texture: AtlasTexture
@export var render_order: RenderOrder = RenderOrder.ITEM
@export var color: Color = Color.WHITE
@export_storage var visible: bool = true

var _sprite: Sprite2D = null:
	get:
		if _sprite == null:
			_sprite = Sprite2D.new()
			_sprite.texture = texture
			_sprite.visible = visible
			_sprite.modulate = color
			_sprite.z_index = render_order
			_sprite.centered = false
		return _sprite


func get_sprite() -> Sprite2D:
	return _sprite


func process_message_execute(message: Message) -> void:
	match message.type:
		"position_update":
			if message.data.has("position"):
				_sprite.position = _parent_entity.map_data.grid_to_world(message.data["position"])
			else:
				_sprite.queue_free()


func get_component_type() -> Type:
	return Type.Drawable
