extends Control

const CONVERSION_SCRIPT_PATH: String = "pysisl/json_to_sisl.py"

signal forward_sisl(sisl: String)

@onready var json_label = %JSONLabel
@onready var sisl_label = %SISLLabel

func _on_json_received(json: String) -> void:
	json_label.text = json
	var output = []
	if OS.execute("python", [CONVERSION_SCRIPT_PATH, json.c_escape()], output) == OK:
		sisl_label.text = output[0].strip_edges()
	else:
		sisl_label.text = "could not convert to SISL"

func _on_next_button_pressed():
	forward_sisl.emit(sisl_label.text)
