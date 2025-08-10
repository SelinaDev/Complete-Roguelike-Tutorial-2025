class_name UseTargetPick
extends UseTarget

@export var radius: int = 0
@export var can_target_self: bool = true


func get_targets(user: Entity) -> Array[Entity]:
		var position := PositionComponent.get_entity_position(user)
		var reticle_config := ReticleConfig.new(user.map_data, position).with_radius(radius)
		SignalBus.reticle_requested.emit(reticle_config)
		var targets = await SignalBus.reticle_targets_selected
		if user in targets and not can_target_self:
			Log.send_log(
				"%s cannot target itself" % user.get_entity_name().capitalize(),
				Log.COLOR_IMPOSSIBLE
			)
			return []
		return targets
