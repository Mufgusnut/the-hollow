extends CharacterBody3D
class_name FamiliarController
## Shared movement/casting glue for every playable familiar. Species
## scripts (Cat.gd, and Crow/Snake/Rat later) extend this and override
## the exported stats or bolt on extra abilities.
##
## Movement supports WASD/left-stick and click-to-move at the same time
## (no mode toggle): any directional input takes over immediately and
## cancels a pending click destination.

@export var move_speed: float = 4.5
@export var acceleration: float = 14.0
@export var rotation_speed: float = 10.0
@export var arrive_distance: float = 0.15
@export var jump_velocity: float = 4.5

## Ambient/exposed suspicion stats feeding the future suspicion system
## described in GDD.md "Familiar Bias" — not wired to gameplay yet.
@export var suspicion_baseline: float = 0.3
@export var suspicion_when_exposed: float = 0.6

## Falling below this Y teleports the familiar back to the last position
## it stood on solid ground, with a brief blink so it reads as a recovery
## rather than a teleport bug.
@export var fall_recovery_y: float = -10.0
@export var blink_duration: float = 1.0
@export var blink_interval: float = 0.1

var _move_target: Vector3
var _has_move_target: bool = false
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var _last_safe_position: Vector3
var _is_recovering: bool = false

@onready var spell_caster: SpellCaster = get_node_or_null("SpellCaster") as SpellCaster
@onready var _visual: Node3D = get_node_or_null("Visual")

## Resolved lazily (not @onready) since sibling nodes in the scene tree
## may not have registered to the "camera_rig" group yet at this node's
## _ready time — first real use happens in _physics_process, after every
## node's _ready has run.
var _camera_rig: Node3D = null

func _ready() -> void:
	_last_safe_position = global_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_move"):
		_handle_click()

func _physics_process(delta: float) -> void:
	var input_dir := _get_camera_relative_input()

	if input_dir != Vector3.ZERO:
		_has_move_target = false
		_move(input_dir, delta)
	elif _has_move_target:
		_move_to_target(delta)
	else:
		_apply_friction(delta)

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		velocity.y -= _gravity * delta

	move_and_slide()

	if is_on_floor():
		_last_safe_position = global_position
	elif global_position.y < fall_recovery_y and not _is_recovering:
		_recover_from_fall()

func _handle_click() -> void:
	var result := _raycast_from_mouse()
	if result.is_empty():
		return
	var collider = result.get("collider")
	if collider is Node and spell_caster and spell_caster.cast_on(collider):
		return
	set_move_target(result.position)

func _raycast_from_mouse() -> Dictionary:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return {}
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(from, to)
	return get_world_3d().direct_space_state.intersect_ray(query)

func _get_camera_relative_input() -> Vector3:
	var raw := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if raw == Vector2.ZERO:
		return Vector3.ZERO

	if _camera_rig == null:
		_camera_rig = get_tree().get_first_node_in_group("camera_rig")

	var basis := Basis.IDENTITY
	if _camera_rig:
		basis = _camera_rig.global_transform.basis

	var forward := -basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var right := basis.x
	right.y = 0.0
	right = right.normalized()

	return (right * raw.x + forward * -raw.y).normalized()

func _move(direction: Vector3, delta: float) -> void:
	var target_velocity := direction * move_speed
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta * move_speed)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta * move_speed)
	_face_direction(direction, delta)

func _move_to_target(delta: float) -> void:
	var to_target := _move_target - global_position
	to_target.y = 0.0
	if to_target.length() <= arrive_distance:
		_has_move_target = false
		_apply_friction(delta)
		return
	_move(to_target.normalized(), delta)

func _apply_friction(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta * move_speed)
	velocity.z = move_toward(velocity.z, 0.0, acceleration * delta * move_speed)

func _face_direction(direction: Vector3, delta: float) -> void:
	if direction.length() < 0.01:
		return
	var target_angle := atan2(direction.x, direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)

func set_move_target(world_position: Vector3) -> void:
	_move_target = world_position
	_has_move_target = true

func clear_move_target() -> void:
	_has_move_target = false

## Repositions the familiar (e.g. arriving through a SceneDoor) and
## resets everything that would otherwise still reflect the old spot:
## the fall-recovery anchor, residual velocity, and any pending
## click-to-move target.
func teleport_to(world_position: Vector3, yaw: float) -> void:
	global_position = world_position
	rotation.y = yaw
	_last_safe_position = world_position
	velocity = Vector3.ZERO
	clear_move_target()

func _recover_from_fall() -> void:
	_is_recovering = true
	global_position = _last_safe_position
	velocity = Vector3.ZERO
	clear_move_target()
	_blink()

func _blink() -> void:
	if _visual == null:
		_is_recovering = false
		return
	var elapsed := 0.0
	while elapsed < blink_duration:
		_visual.visible = not _visual.visible
		await get_tree().create_timer(blink_interval).timeout
		elapsed += blink_interval
	_visual.visible = true
	_is_recovering = false
