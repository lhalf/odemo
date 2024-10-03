extends MeshInstance3D

@onready var input_light: OmniLight3D = %InputLight
@onready var output_light: OmniLight3D = %OutputLight
@onready var flash_timer = %FlashTimer
@onready var animation_player = %AnimationPlayer
@onready var output_wire = %Wire

@export var input_flashing: bool :
	set(value):
		input_flashing = value
		input_light.visible = input_flashing

@export var output_flashing: bool :
	set(value):
		output_flashing = value
		output_light.visible = output_flashing

@export var cables_connected: bool :
	set(value):
		# only change cables when state changes
		if cables_connected == value:
			return
		cables_connected = value
		if cables_connected:
			animation_player.play("insert_cables")
		else:
			animation_player.play_backwards("insert_cables")

func _set_output_active(to: bool) -> void:
	if to and not _is_output_active():
		output_flashing = true
		output_wire.get_active_material(0).get_next_pass().set_shader_parameter("shine_speed", -3)
	if not to and _is_output_active():
		output_flashing = false
		output_wire.get_active_material(0).get_next_pass().set_shader_parameter("shine_speed", 0)

func _on_flash_timer_timeout():
	input_light.light_energy = 1 if input_light.light_energy == 0 else 0
	output_light.light_energy = 1 if output_light.light_energy == 0 else 0

func _is_output_active() -> bool:
	return output_wire.get_active_material(0).get_next_pass().get_shader_parameter("shine_speed") == -3
