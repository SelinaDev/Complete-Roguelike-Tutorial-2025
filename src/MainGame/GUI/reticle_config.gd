class_name ReticleConfig
extends RefCounted

enum Info {
	None,
	Look,
}


var initial_position: Vector2i
var map_data: MapData
var info: Info = Info.None
var radius: int = 0


func _init(map_data: MapData, initial_position: Vector2i) -> void:
	self.map_data = map_data
	self.initial_position = initial_position


func with_info(info: Info) -> ReticleConfig:
	self.info = info
	return self


func with_radius(radius: int) -> ReticleConfig:
	self.radius = radius
	return self
