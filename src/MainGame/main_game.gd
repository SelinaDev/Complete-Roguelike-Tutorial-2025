extends GameState

@onready var health_bar: Bar = %HealthBar


func _on_world_player_set(player_entity: Entity) -> void:
	await ready
	var player_durability: DurabilityComponent = player_entity.get_component(Component.Type.Durability)
	health_bar.set_values(player_durability.hp, player_durability.max_hp)
	player_durability.hp_changed.connect(health_bar.set_values)
	
	Log.send_log("Hello and welcome, to yet another dungeon!")
