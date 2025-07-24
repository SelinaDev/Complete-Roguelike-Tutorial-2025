class_name Message
extends RefCounted

var type: String
var flags: Dictionary[String, bool] = {}
var data: Dictionary[String, Variant] = {}
var calculations: Dictionary[String, MessageCalculation] = {}

func _init(type: String) -> void:
	self.type = type
	self.flags = flags
	self.data = data


func with_flags(flags: Dictionary[String, bool]) -> Message:
	self.flags = flags
	return self


func with_data(data: Dictionary[String, Variant]) -> Message:
	self.data = data
	return self


func get_calculation(key: String) -> MessageCalculation:
	return calculations.get_or_add(key, MessageCalculation.new())
