class_name LookInfoContainer
extends InfoContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel


func set_look_info(tile: Tile, entities: Array[Entity]) -> void:
	var info_text := "You don't know what's here"
	if tile and tile.is_explored:
		var info_template = "You see here:\n[ul]%s%s\n[/ul]"
		if not tile.is_in_view:
			info_template = "You remember here:\n[ul]%s%s\n[/ul]"
			entities = entities.filter(func(e: Entity) -> bool: return e.has_component(Component.Type.Rememberable))
		info_text = info_template % [
			entities.reduce(func(list: String, entity: Entity) -> String:
			return list + entity.get_entity_name(true) + "\n",
			""
			),
			tile.template.name
		]
	rich_text_label.parse_bbcode(info_text)
