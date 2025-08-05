class_name InfoContainer
extends MarginContainer

signal closed


func close() -> void:
	closed.emit()
	_close()


func _close() -> void:
	pass
