extends PanelContainer


func _ready() -> void:
	SignalBus.spawn_info_container.connect(_on_spawn_info_container)


func _on_spawn_info_container(info_container: InfoContainer) -> void:
	get_child(get_child_count() - 1).visible = false
	add_child(info_container)
	info_container.closed.connect(_on_info_container_closed.bind(info_container))


func _on_info_container_closed(info_container: InfoContainer) -> void:
	remove_child(info_container)
	info_container.queue_free()
	get_child(get_child_count() - 1).visible = true
