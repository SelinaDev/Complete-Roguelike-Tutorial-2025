class_name StairsComponent
extends Component

@export var descends_by: int = 1
@export_storage var target_floor: int


func set_current_floor(current_floor: int) -> void:
	target_floor = current_floor + descends_by


func get_component_type() -> Type:
	return Type.Stairs
