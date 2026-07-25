extends Node3D
class_name CameraRig
## Fixed-angle isometric follow rig: tracks a target's XZ position with
## smoothing but never rotates itself, keeping the isometric read
## consistent (per GDD.md "Camera, Controls & Input"). The rig's own
## rotation_degrees (set in the scene) is the view angle; the Camera3D
## child sits behind it along local +Z with zero local rotation, so it
## always looks back at the rig's origin no matter what angle is chosen.

@export var target_path: NodePath
@export var follow_speed: float = 6.0
@export var ortho_size: float = 10.0

@onready var _camera: Camera3D = $Camera3D
var _target: Node3D

func _ready() -> void:
	add_to_group("camera_rig")
	_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	_camera.size = ortho_size
	if target_path != NodePath(""):
		_target = get_node(target_path)
	snap_to_target()

func _process(delta: float) -> void:
	if _target == null:
		return
	var goal := _target.global_position
	var weight := 1.0 - exp(-follow_speed * delta)
	global_position = global_position.lerp(Vector3(goal.x, global_position.y, goal.z), weight)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_reset"):
		snap_to_target()

func snap_to_target() -> void:
	if _target:
		global_position = Vector3(_target.global_position.x, global_position.y, _target.global_position.z)

func set_target(node: Node3D) -> void:
	_target = node
