class_name Tile
extends Resource

@export_storage var template: TileTemplate
@export_storage var position: Vector2i
@export_storage var is_explored: bool = false:
	set(value):
		if not is_explored and value:
			is_explored = value
			_sprite.show()
@export_storage var is_in_view: bool = false:
	set(value):
		is_in_view = value
		_sprite.modulate = template.light_color if is_in_view else template.dark_color
		if is_in_view and not is_explored:
			is_explored = true

var _sprite: Sprite2D = null:
	get:
		if _sprite == null:
			_sprite = Sprite2D.new()
			_sprite.position = Vector2(position) * ProjectSettings.get_setting("global/tile_size")
			_sprite.centered = false
			_sprite.modulate = template.light_color if is_in_view else template.dark_color
			_sprite.texture = template.texture
			_sprite.visible = is_explored
		return _sprite


var blocks_movement: bool:
	get:
		return template.blocks_movement
var blocks_sight: bool:
	get:
		return template.blocks_sight


func setup(template: TileTemplate, position: Vector2i) -> void:
	self.template = template
	self.position = position


func get_sprite() -> Sprite2D:
	return _sprite
