extends AnimatableBody3D
class_name TelekinesisProp
## A small object blocking a path that only telekinesis can clear — the
## traversal gate the GDD calls out as the spell's first use. Floats
## straight up and out of the way so it never has to worry about
## clipping through whatever geometry is nearby.

signal moved_aside

@export var push_direction: Vector3 = Vector3.UP
@export var push_distance: float = 3.0
@export var move_duration: float = 0.6

var _moved: bool = false

func apply_telekinesis(_caster_position: Vector3) -> void:
	if _moved:
		return
	_moved = true
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self, "global_position", global_position + push_direction.normalized() * push_distance, move_duration
	)
	tween.tween_callback(func(): moved_aside.emit())
