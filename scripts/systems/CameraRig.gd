extends Node3D
class_name CameraRig
## Isometric follow rig: tracks a target's XZ position with smoothing and
## keeps a fixed pitch, but yaw can be orbited by holding right-click and
## dragging (per user request) — "camera_reset" (C) snaps both position
## and yaw back to default. The rig's rotation_degrees (set in the scene)
## is the base view angle; the Camera3D child sits behind it along local
## +Z with zero local rotation, so it always looks back at the rig's
## origin no matter what yaw it's currently at.

@export var target_path: NodePath
@export var follow_speed: float = 6.0
@export var ortho_size: float = 10.0
@export var orbit_sensitivity: float = 0.005

@onready var _camera: Camera3D = $Camera3D
var _target: Node3D
var _default_yaw: float
var _orbiting: bool = false

func _ready() -> void:
	add_to_group("camera_rig")
	_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	_camera.size = ortho_size
	_default_yaw = rotation.y
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
		rotation.y = _default_yaw
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		_orbiting = event.pressed
		return

	if event is InputEventMouseMotion and _orbiting:
		rotation.y -= event.relative.x * orbit_sensitivity

func snap_to_target() -> void:
	if _target:
		global_position = Vector3(_target.global_position.x, global_position.y, _target.global_position.z)

func set_target(node: Node3D) -> void:
	_target = node
