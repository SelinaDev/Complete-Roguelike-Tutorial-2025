@tool
extends EditorScript

const ENTITIES_SOURCE_PATH = "res://resources/entities/"
const TILES_SOURCE_PATH = "res://resources/tiles/"
const TARGET_PATH = "res://resources/ResourceCollection.tres"

func _run() -> void:
	var collection := ResourceCollection.new()
	
	# Pack Entities
	
	var file_names := DirAccess.get_files_at(ENTITIES_SOURCE_PATH)
	for file_name: String in file_names:
		var file = load(ENTITIES_SOURCE_PATH.path_join(file_name))
		if file is Entity:
			var entity_key: String = file_name.trim_suffix(".tres")
			collection.entities[entity_key] = file
	
	# Pack Tiles
	
	file_names = DirAccess.get_files_at(TILES_SOURCE_PATH)
	for file_name: String in file_names:
		var file = load(TILES_SOURCE_PATH.path_join(file_name))
		if file is TileTemplate:
			var tile_key: String = file_name.trim_suffix(".tres")
			collection.tiles[tile_key] = file
	
	DirAccess.remove_absolute(TARGET_PATH)
	ResourceSaver.save(collection, TARGET_PATH)
