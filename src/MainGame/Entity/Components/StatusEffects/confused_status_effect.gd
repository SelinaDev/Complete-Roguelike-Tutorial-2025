class_name ConfusedStatusEffect
extends StatusEffect

const DIRECTIONS = [
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT + Vector2i.UP,
	Vector2i.LEFT + Vector2i.DOWN,
	Vector2i.RIGHT + Vector2i.UP,
	Vector2i.RIGHT + Vector2i.DOWN
]

@export var duration: int


func start(entity: Entity) -> void:
	Log.send_log("%s's eyes glaze over as they start moving erratically." % entity.get_entity_name().capitalize())


func end(entity: Entity) -> void:
	Log.send_log("%s is no longer confused." % entity.get_entity_name().capitalize())


func merge(new_effect: StatusEffect) -> void:
	if new_effect is ConfusedStatusEffect:
		duration += new_effect.duration


func process_message_precalculate(entity: Entity, message: Message) -> void:
	match message.type:
		"get_action":
			message.data.get("proposed_actions").append(
				ProposedAction.new().with_priority(ProposedAction.Priority.FORCED).with_action(
					BumpAction.new(entity, DIRECTIONS.pick_random())
				)
			)


func process_message_execute(_entity: Entity, message: Message) -> void:
	match message.type:
		"turn_end":
			duration -= 1
			if duration <= 0:
				effect_ended.emit()
			else:
				effect_changed.emit()


func get_type() -> String:
	return "confused"
