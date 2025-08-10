class_name UsableComponent
extends Component

enum UsageType {
	Drink,
	Read,
	Activate,
}

@export var effects: Array[UseEffect]
@export var targeting: UseTarget
@export var usage_type: UsageType = UsageType.Activate


func activate(_user: Entity, targets: Array[Entity]) -> bool:
	var did_use := false
	for target: Entity in targets:
		for effect: UseEffect in effects:
			did_use = effect.apply(target, _user) or did_use
	return did_use


static func get_use_target(entity: Entity) -> UseTarget:
	var usable: UsableComponent = entity.get_component(Component.Type.Use)
	if not usable:
		return null
	return usable.targeting


func get_component_type() -> Type:
	return Type.Use
