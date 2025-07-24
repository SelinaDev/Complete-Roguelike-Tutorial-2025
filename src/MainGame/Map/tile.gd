class_name Tile
extends Resource

@export_storage var template: TileTemplate
@export_storage var position: Vector2i

var _sprite: Sprite2D = null:
	get:
		if _sprite == null:
			_sprite = Sprite2D.new()
			_sprite.position = Vector2(position) * ProjectSettings.get_setting("global/tile_size")
			_sprite.centered = false
			_sprite.modulate = template.light_color
			_sprite.texture = template.texture
		return _sprite


var blocks_movement: bool:
	get:
		return template.blocks_movement


func _init(template: TileTemplate, position: Vector2i) -> void:
	self.template = template
	self.position = position


func get_sprite() -> Sprite2D:
	return _sprite
