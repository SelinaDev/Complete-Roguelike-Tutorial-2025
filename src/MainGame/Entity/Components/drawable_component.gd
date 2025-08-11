class_name DrawableComponent
extends Component

enum RenderOrder {
	MAP_OBJECT,
	CORPSE,
	ITEM,
	ACTOR
}

@export var texture: AtlasTexture:
	set(value):
		texture = value
		_sprite.texture = texture
@export var render_order: RenderOrder = RenderOrder.ITEM:
	set(value):
		render_order = value
		_sprite.z_index = render_order
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		_sprite.modulate = color
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
		"exit_map":
			_sprite.queue_free()
			_sprite = null
		"position_update":
			if message.data.has("position"):
				var position: Vector2i = message.data["position"]
				_sprite.position = _parent_entity.map_data.grid_to_world(position)
				var is_in_view: bool = _parent_entity.map_data.is_in_fov(position)
				if message.data.has("remember_color"):
					_sprite.visible = true
					_sprite.modulate = color if is_in_view else message.data["remember_color"]
				else:
					_sprite.visible = is_in_view
			else:
				_sprite.queue_free()
		"fov_update":
			var fov: Dictionary[Vector2i, bool] = message.data.get("fov", {})
			var position: Vector2i = message.data.get("position", Vector2i(-1, -1))
			var is_in_view: bool = fov.get(position, false)
			if message.data.has("remember_color"):
				_sprite.visible = true
				_sprite.modulate = color if is_in_view else message.data["remember_color"]
			else:
				_sprite.visible = is_in_view
		"visual_update":
			if message.data.has("texture"):
				texture = message.data["texture"]
			if message.data.has("color"):
				color = message.data["color"]
			if message.data.has("render_order"):
				render_order = message.data["render_order"]


func get_component_type() -> Type:
	return Type.Drawable
