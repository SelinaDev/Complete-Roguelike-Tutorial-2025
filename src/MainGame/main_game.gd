class_name MainGame
extends GameState

const GAME_MENU = preload("res://src/MainGame/GUI/game_menu.tscn")

@onready var health_bar: Bar = %HealthBar


func _ready() -> void:
	SignalBus.spawn_game_menu.connect(add_child)


func _on_world_player_set(player_entity: Entity) -> void:
	await ready
	var player_durability: DurabilityComponent = player_entity.get_component(Component.Type.Durability)
	health_bar.set_values(player_durability.hp, player_durability.max_hp)
	player_durability.hp_changed.connect(health_bar.set_values)
	
	Log.send_log("Hello and welcome, to yet another dungeon!")


static func spawn_game_menu(title: String, options: Array) -> GameMenu:
	var game_menu: GameMenu = GAME_MENU.instantiate()
	SignalBus.spawn_game_menu.emit(game_menu)
	game_menu.setup(title, options)
	return game_menu
