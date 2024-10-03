extends Control

const VALIDATION_SCRIPT_PATH: String = "pysisl/validate_sisl.py"
const VALID_COLOR: Color = Color.GREEN
const INVALID_COLOR: Color = Color.RED


@onready var sisl_edit = %SISLEdit
@onready var terminal = %Terminal
@onready var schema_edit = %SchemaEdit
@onready var validate_wait = %ValidateWait

func _on_sisl_received(sisl: String) -> void:
	_validate()
	sisl_edit.text = sisl

func _validate():
	var output = []
	OS.execute("python", [VALIDATION_SCRIPT_PATH, schema_edit.text.strip_escapes().c_escape(), sisl_edit.text.c_escape()], output)
	terminal.text = output[0].strip_edges()
	if terminal.text == "Passed schema validation":
		terminal.modulate = VALID_COLOR
	else:
		terminal.modulate = INVALID_COLOR

func _reset_validate_wait():
	validate_wait.stop()
	validate_wait.start()
