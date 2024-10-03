extends Control

const OK_JSON: Color = Color.WHITE
const BAD_JSON: Color = Color.RED

signal json_received(json: String)

@onready var json_input = %JSONInput

var mouse_over_file_drop: bool = false

# to connect signal, sadly can't use setter syntax
func _set_mouse_over_file_drop(to: bool) -> void:
	mouse_over_file_drop = to

func _ready() -> void:
	get_tree().root.files_dropped.connect(_on_file_dropped)

func _on_json_input_text_changed(_ignore):
	if json_input.modulate == BAD_JSON:
		json_input.modulate = OK_JSON

func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		_enter_json_from_input_label()

func _enter_json_from_input_label() -> void:
	_on_json_entered(json_input.text)

func _on_json_entered(json: String) -> void:
	if _is_json_valid(json):
		json_input.modulate = OK_JSON
		json_received.emit(json)
	else:
		json_input.modulate = BAD_JSON

func _is_json_valid(json: String) -> bool:
	return JSON.new().parse(json) == OK

func _on_file_dropped(files: PackedStringArray) -> void:
	# mouse entered signal only emitted when focus on window restored
	await get_tree().create_timer(0.01).timeout
	if not mouse_over_file_drop:
		return
	var file = FileAccess.open(files[0], FileAccess.READ)
	if not file:
		json_input.set_text("failed to open file")
		json_input.modulate = BAD_JSON
	json_input.clear()
	_on_json_entered(file.get_as_text())
