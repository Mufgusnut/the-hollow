extends Node3D
class_name StoneWallRing
## Builds a rectangular stone perimeter wall from four StaticBody3D
## segments — the village's town wall. One side can have a gate: a gap
## of gap_width centered at gap_center (a local offset along that
## side's length) left open for a road to pass through.
##
## Sides are plain int constants rather than a typed enum: a
## class_name-qualified enum used both as an @export type and a
## function parameter type makes Godot's parser see the enum and its
## "StoneWallRing.Side" qualified form as mismatched types, which is a
## hard parse error, not just a warning.

const SIDE_NORTH := 0
const SIDE_SOUTH := 1
const SIDE_EAST := 2
const SIDE_WEST := 3

@export var half_width: float = 20.0
@export var half_depth: float = 14.0
@export var wall_height: float = 3.0
@export var wall_thickness: float = 0.6
@export var wall_color: Color = Color(0.5, 0.48, 0.44)
@export var gap_side: int = SIDE_EAST
@export var gap_center: float = 0.0
@export var gap_width: float = 3.0

func _ready() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = wall_color
	mat.roughness = 0.95

	_build_edge(SIDE_NORTH, mat)
	_build_edge(SIDE_SOUTH, mat)
	_build_edge(SIDE_EAST, mat)
	_build_edge(SIDE_WEST, mat)

func _build_edge(side: int, mat: StandardMaterial3D) -> void:
	var full_length := half_width * 2.0 if (side == SIDE_NORTH or side == SIDE_SOUTH) else half_depth * 2.0

	if side == gap_side and gap_width > 0.0:
		var seg1_len := (full_length / 2.0 + gap_center) - gap_width / 2.0
		var seg2_len := (full_length / 2.0 - gap_center) - gap_width / 2.0
		var seg1_center := -full_length / 2.0 + seg1_len / 2.0
		var seg2_center := full_length / 2.0 - seg2_len / 2.0
		_add_segment(side, seg1_center, seg1_len, mat)
		_add_segment(side, seg2_center, seg2_len, mat)
	else:
		_add_segment(side, 0.0, full_length, mat)

func _add_segment(side: int, center_offset: float, length: float, mat: StandardMaterial3D) -> void:
	if length <= 0.01:
		return

	var pos := Vector3.ZERO
	var size := Vector3.ZERO
	match side:
		SIDE_NORTH:
			pos = Vector3(center_offset, wall_height / 2.0, half_depth)
			size = Vector3(length, wall_height, wall_thickness)
		SIDE_SOUTH:
			pos = Vector3(center_offset, wall_height / 2.0, -half_depth)
			size = Vector3(length, wall_height, wall_thickness)
		SIDE_EAST:
			pos = Vector3(half_width, wall_height / 2.0, center_offset)
			size = Vector3(wall_thickness, wall_height, length)
		SIDE_WEST:
			pos = Vector3(-half_width, wall_height / 2.0, center_offset)
			size = Vector3(wall_thickness, wall_height, length)

	var body := StaticBody3D.new()
	body.position = pos
	add_child(body)

	var box := BoxMesh.new()
	box.size = size
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = box
	mesh_instance.material_override = mat
	body.add_child(mesh_instance)

	var shape := BoxShape3D.new()
	shape.size = size
	var collision := CollisionShape3D.new()
	collision.shape = shape
	body.add_child(collision)
