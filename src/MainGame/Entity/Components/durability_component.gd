class_name DurabilityComponent
extends Component

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


func set_hp(new_hp: int) -> void:
	hp = clampi(new_hp, 0, max_hp)
	if hp == 0 and _parent_entity:
		_parent_entity.process_message(Message.new("die"))


func process_message_execute(message: Message) -> void:
	match message.type:
		"take_damage":
			var actual_amount := take_damage(message.get_calculation("damage").get_result())
			var damage_source: Entity = message.data.get("source")
			_last_source_of_damage = damage_source
			if actual_amount > 0:
				print("%s hit %s for %d damage!" % [
					damage_source.name,
					_parent_entity.name,
					actual_amount
				])
			else:
				print("%s hit %s, but did no damage." % [
					damage_source.name,
					_parent_entity.name
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
