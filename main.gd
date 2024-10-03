extends Node3D

const PYSISL_WHEEL_PATH: String = "pysisl/pysisl-0.0.13-py3-none-any"

enum STATE {RESET, LOWSIDE, SEF, HIGHSIDE}

const TRANSITIONS: Array = [STATE.RESET, STATE.LOWSIDE, STATE.SEF, STATE.HIGHSIDE]

@onready var animations = %Animations

var state_index: int = 0 :
	set(value):
		if value >= TRANSITIONS.size():
			state_index = 0
		elif value <= 0:
			state_index = 0 # cannot go backwards past RESET
		else:
			state_index = value

func _ready():
	# add error handling for failing to install pysisl
	OS.execute("pip", ["install", PYSISL_WHEEL_PATH])

func _next(_ignore) -> void:
	state_index += 1
	animations.play(STATE.keys()[TRANSITIONS[state_index]])

func _back(_ignore) -> void:
	animations.play_backwards(STATE.keys()[TRANSITIONS[state_index]])
	state_index -= 1
