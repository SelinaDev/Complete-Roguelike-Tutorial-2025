class_name MainGame
extends GameState

const GAME_MENU = preload("res://src/MainGame/GUI/game_menu.tscn")

@export_file("*tscn") var main_menu_scene

@onready var health_bar: Bar = %HealthBar


func _ready() -> void:
	SignalBus.spawn_game_menu.connect(add_child)
	SignalBus.save.connect(_on_save)


func _on_world_player_set(player_entity: Entity) -> void:
	var player_durability: DurabilityComponent = player_entity.get_component(Component.Type.Durability)
	health_bar.set_values(player_durability.hp, player_durability.max_hp)
	player_durability.hp_changed.connect(health_bar.set_values)


func _on_save(map_data: MapData, and_quit: bool) -> void:
	var did_save = ResourceSaver.save(map_data, SAVE_PATH)
	if and_quit:
		get_tree().quit()
	else:
		transition_requested.emit(main_menu_scene)


func enter(data: Dictionary = {}) -> void:
	var map: Map = get_node("VBoxContainer/SubViewportContainer/SubViewport/World/Map")

	if data.get("load_game", false) and FileAccess.file_exists(SAVE_PATH):
		var map_data: MapData = load(SAVE_PATH)
		map.set_map_data(map_data)
		map_data.reactivate()
		Log.send_log("Hello and welcome back, to the dungeon!")
	else:
		map.generate_new_dungeon()
		Log.send_log("Hello and welcome, to yet another dungeon!")



static func spawn_game_menu(title: String, options: Array, small_mode: bool = false) -> GameMenu:
	var game_menu: GameMenu = GAME_MENU.instantiate()
	SignalBus.spawn_game_menu.emit(game_menu)
	game_menu.setup(title, options, small_mode)
	return game_menu
