class_name DurabilityComponent
extends Component

signal hp_changed(hp, max_hp)

@export_category("Stats")
@export var max_hp: int:
	set = set_max_hp
@export_storage var hp: int = 1:
	set = set_hp
@export var defense: int

@export_category("Death Config")
@export var death_texture: AtlasTexture = preload("res://resources/default_death_texture.tres")
@export var death_color: Color = Color.DARK_RED
@export var death_render_order: DrawableComponent.RenderOrder = DrawableComponent.RenderOrder.CORPSE
@export var death_removes_movement_blocker: bool = true

var _last_source_of_damage: Entity


func _enter_entity() -> void:
	hp = max_hp


func set_max_hp(new_max_hp: int) -> void:
	var difference = maxi(0, new_max_hp - max_hp)
	max_hp = maxi(0, new_max_hp)
	hp += difference
	hp_changed.emit(hp, max_hp)


func set_hp(new_hp: int) -> void:
	hp = clampi(new_hp, 0, max_hp)
	hp_changed.emit(hp, max_hp)
	if hp == 0 and _parent_entity:
		_parent_entity.process_message(Message.new("die"))


func process_message_precalculate(message: Message) -> void:
	match message.type:
		"take_damage":
			message.get_calculation("damage").terms.append(-1 * defense)


func process_message_execute(message: Message) -> void:
	match message.type:
		"take_damage":
			var actual_amount := take_damage(message.get_calculation("damage").get_result())
			var damage_source: Entity = message.data.get("source")
			var hit_verb: String = message.data.get("verb", "hit")
			var source_name = "you" if damage_source.has_component(Component.Type.Player) else damage_source.get_entity_name()
			var target_is_player: bool = _parent_entity.has_component(Component.Type.Player)
			var target_name = "you" if target_is_player else _parent_entity.get_entity_name()
			if actual_amount > 0:
				_last_source_of_damage = damage_source
				var log_color: Color = Log.COLOR_NEGATIVE if target_is_player else Log.COLOR_NEUTRAL
				Log.send_log("%s %s %s for %d damage!" % [
					source_name.capitalize(),
					hit_verb,
					target_name,
					actual_amount,
				], log_color)
			else:
				Log.send_log("%s %s %s, but did no damage" % [
					source_name.capitalize(),
					hit_verb,
					target_name
				])
		"die":
			var should_die: bool = message.data.get("should_die", true)
			if not should_die:
				return
			if hp > 0:
				hp = 0
				return
			if death_removes_movement_blocker:
				_parent_entity.remove_component(Component.Type.MovementBlocker)
			_parent_entity.process_message(Message.new("visual_update").with_data({
				"texture": death_texture,
				"color": death_color,
				"render_order": death_render_order
			}))
			var is_player := _parent_entity.get_component(Component.Type.Player)
			var log_text: String
			var log_color: Color
			if is_player:
				log_text = "[pulse freq=1.0 color=#%s]You died![/pulse]" % Log.COLOR_IMPORTANT.to_html(false)
				log_color = Log.COLOR_NEUTRAL
			else:
				log_text = "%s has died." % _parent_entity.get_entity_name().capitalize()
				log_color = Log.COLOR_POSITIVE
			Log.send_log(log_text, log_color)
			_parent_entity.name = "Remains of %s" % _parent_entity.name
			_parent_entity.remove_component(type)
			_parent_entity.process_message(Message.new("died").with_data({"source": _last_source_of_damage}))


func take_damage(amount: int) -> int:
	amount = maxi(0, amount)
	var old_hp := hp
	hp -= amount
	return old_hp - hp


func get_component_type() -> Type:
	return Type.Durability
