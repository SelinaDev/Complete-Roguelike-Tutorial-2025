class_name Log
extends ScrollContainer

const COLOR_NEUTRAL = Color.WHITE
const COLOR_IMPORTANT = Color.RED
const COLOR_NEGATIVE = Color.LIGHT_CORAL
const COLOR_POSITIVE = Color.LIGHT_GREEN
const COLOR_IMPOSSIBLE = Color.GRAY

@onready var log_list: VBoxContainer = $LogList

var _last_log_message: LogMessage = null


func _ready() -> void:
	SignalBus.log_message_sent.connect(add_log_message)


func add_log_message(text: String, color: Color) -> void:
	if _last_log_message and _last_log_message.plain_text == text:
		_last_log_message.count += 1
	else:
		var log_message := LogMessage.new(text, color)
		_last_log_message = log_message
		log_list.add_child(log_message)
		await get_tree().process_frame
		ensure_control_visible(log_message)


static func send_log(text: String, color: Color = COLOR_NEUTRAL) -> void:
	SignalBus.log_message_sent.emit(text, color)
