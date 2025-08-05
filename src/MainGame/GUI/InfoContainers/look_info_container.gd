class_name LookInfoContainer
extends InfoContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel


func set_look_info(tile: Tile, entities: Array[Entity]) -> void:
	var info_text := "You don't know what's here"
	if tile:
		if not tile.is_in_view and tile.is_explored:
			info_text = "You remember here:\n[ul]%s\n[/ul]" % [
				tile.template.name
			]
		else:
			info_text = "You see here:\n[ul]%s%s\n[/ul]" % [
				entities.reduce(func(list: String, entity: Entity) -> String:
				return list + entity.get_entity_name(true) + "\n",
				""
				),
				tile.template.name
			]
	rich_text_label.parse_bbcode(info_text)
