extends Node
## Builds the entire input map in code (autoload, runs before any other
## node's _ready) instead of hand-edited resource blobs in project.godot,
## so keyboard, mouse, and controller bindings all live in one readable
## place. See GDD.md "Camera, Controls & Input".

const KEY_BINDINGS := {
	&"move_up": KEY_W,
	&"move_down": KEY_S,
	&"move_left": KEY_A,
	&"move_right": KEY_D,
	&"interact": KEY_E,
	&"camera_reset": KEY_C,
	&"cast_spell": KEY_F,
	&"jump": KEY_SPACE,
	&"spell_slot_1": KEY_1,
	&"spell_slot_2": KEY_2,
	&"spell_slot_3": KEY_3,
	&"spell_slot_4": KEY_4,
	&"spell_slot_5": KEY_5,
	&"spell_slot_6": KEY_6,
	&"spell_slot_7": KEY_7,
	&"spell_slot_8": KEY_8,
}

func _ready() -> void:
	for action in KEY_BINDINGS:
		_ensure_action(action)
		_add_key(action, KEY_BINDINGS[action])

	_ensure_action(&"click_move")
	_add_mouse_button(&"click_move", MOUSE_BUTTON_LEFT)

	_add_joy_button(&"cast_spell", JOY_BUTTON_X)
	_add_joy_button(&"interact", JOY_BUTTON_A)
	_add_joy_button(&"jump", JOY_BUTTON_B)
	_add_joy_button(&"camera_reset", JOY_BUTTON_BACK)
	_add_joy_button(&"spell_slot_1", JOY_BUTTON_DPAD_UP)

	_add_joy_axis(&"move_left", JOY_AXIS_LEFT_X, -1.0)
	_add_joy_axis(&"move_right", JOY_AXIS_LEFT_X, 1.0)
	_add_joy_axis(&"move_up", JOY_AXIS_LEFT_Y, -1.0)
	_add_joy_axis(&"move_down", JOY_AXIS_LEFT_Y, 1.0)

func _ensure_action(action: StringName, deadzone: float = 0.2) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action, deadzone)

func _add_key(action: StringName, keycode: int) -> void:
	var ev := InputEventKey.new()
	ev.physical_keycode = keycode
	InputMap.action_add_event(action, ev)

func _add_mouse_button(action: StringName, button_index: int) -> void:
	var ev := InputEventMouseButton.new()
	ev.button_index = button_index
	InputMap.action_add_event(action, ev)

func _add_joy_button(action: StringName, button_index: int) -> void:
	var ev := InputEventJoypadButton.new()
	ev.button_index = button_index
	InputMap.action_add_event(action, ev)

func _add_joy_axis(action: StringName, axis: int, direction: float) -> void:
	var ev := InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = direction
	InputMap.action_add_event(action, ev)
