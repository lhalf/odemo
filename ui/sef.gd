extends Control

const OK_SISL: Color = Color.GREEN
const BAD_SISL: Color = Color.RED

signal schema_verify(sisl: String)
signal sisl_valid(true_false: bool)

@onready var sisl_edit = %SISLEdit
@onready var explanation = %Explanation

func _on_sisl_received(sisl: String) -> void:
	sisl_edit.text = sisl
	_on_sisl_edit_text_changed("")

func _on_sisl_edit_text_changed(_ignore):
	if not _is_syntactically_valid(sisl_edit.text):
		sisl_edit.modulate = BAD_SISL
		sisl_valid.emit(false)
	else:
		explanation.text = "Valid SISL"
		sisl_edit.modulate = OK_SISL
		sisl_valid.emit(true)

func _is_syntactically_valid(sisl: String) -> bool:
	if sisl.count('"') % 2 != 0:
		explanation.text = "Invalid quotes"
		return false
	if sisl.count(' "')*2 != sisl.count('"'):
		explanation.text = "Invalid quotes"
		return false
	if sisl.count('{') != sisl.count('}'):
		explanation.text = "Invalid braces"
		return false
	if sisl.contains(":!"):
		explanation.text = "Invalid seperators"
		return false
	if sisl.count('!') != sisl.count(':'):
		explanation.text = "Invalid seperators"
		return false
	if sisl.count(": !") != sisl.count(", ") + sisl.count("!obj") - sisl.count("{}") + 1:
		explanation.text = "Invalid commas"
		return false
	return true

func _on_next_button_pressed():
	if sisl_edit.modulate == BAD_SISL:
		explanation.text = "Cannot send invalid SISL"
		return
	schema_verify.emit(sisl_edit.text)
