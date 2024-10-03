extends MeshInstance3D

@onready var input_light = %InputLight
@onready var flash_timer = %FlashTimer
@onready var animation_player = %AnimationPlayer
@onready var output_wire = %Wire

@export var flashing: bool :
	set(value):
		flashing = value
		if flashing:
			flash_timer.start()
		else:
			input_light.visible = false
			flash_timer.stop()

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
	if to and output_wire.get_active_material(0).get_next_pass().get_shader_parameter("shine_speed") == 0:
		output_wire.get_active_material(0).get_next_pass().set_shader_parameter("shine_speed", -3)
	if not to and output_wire.get_active_material(0).get_next_pass().get_shader_parameter("shine_speed") == -3:
		output_wire.get_active_material(0).get_next_pass().set_shader_parameter("shine_speed", 0)

func _on_flash_timer_timeout():
	input_light.visible = !input_light.visible
