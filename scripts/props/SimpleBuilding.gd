extends Node3D
class_name SimpleBuilding
## Procedurally builds a simple rectangular building — four walls with
## a door gap on the south side and a pitched roof — so the village's
## shops and houses don't each need hand-authored geometry like the
## witch's cottage got. wall_style picks the material language: plain
## stone, wood planking, or half-timbered (light plaster + dark beams).

enum WallStyle { STONE, WOOD, MIXED }

@export var width: float = 6.0
@export var depth: float = 5.0
@export var wall_height: float = 2.6
@export var wall_style: WallStyle = WallStyle.WOOD
@export var roof_color: Color = Color(0.35, 0.22, 0.15)
@export var door_width: float = 1.2

func _ready() -> void:
	_build_walls()
	_build_roof()

func _build_walls() -> void:
	var mat := _wall_material()
	var thickness := 0.25
	var seg_width := (width - door_width) / 2.0

	_add_wall_segment(Vector3(-(door_width / 2.0 + seg_width / 2.0), wall_height / 2.0, -depth / 2.0), Vector3(seg_width, wall_height, thickness), mat)
	_add_wall_segment(Vector3(door_width / 2.0 + seg_width / 2.0, wall_height / 2.0, -depth / 2.0), Vector3(seg_width, wall_height, thickness), mat)
	_add_wall_segment(Vector3(0, wall_height / 2.0, depth / 2.0), Vector3(width, wall_height, thickness), mat)
	_add_wall_segment(Vector3(-width / 2.0, wall_height / 2.0, 0), Vector3(thickness, wall_height, depth), mat)
	_add_wall_segment(Vector3(width / 2.0, wall_height / 2.0, 0), Vector3(thickness, wall_height, depth), mat)

func _add_wall_segment(pos: Vector3, size: Vector3, mat: StandardMaterial3D) -> void:
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

	if wall_style == WallStyle.MIXED:
		_add_timber_lines(body, size)

func _wall_material() -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	match wall_style:
		WallStyle.STONE:
			mat.albedo_color = Color(0.55, 0.54, 0.5)
			mat.roughness = 0.95
		WallStyle.WOOD:
			mat.albedo_color = Color(0.5, 0.36, 0.22)
			mat.roughness = 0.85
		WallStyle.MIXED:
			mat.albedo_color = Color(0.85, 0.8, 0.7)
			mat.roughness = 0.9
	return mat

func _add_timber_lines(body: StaticBody3D, size: Vector3) -> void:
	var beam_mat := StandardMaterial3D.new()
	beam_mat.albedo_color = Color(0.2, 0.13, 0.08)
	beam_mat.roughness = 0.8

	var is_wide := size.x > size.z
	var beam_count := 3
	for i in range(beam_count):
		var t := (i + 1.0) / (beam_count + 1.0)
		var beam := BoxMesh.new()
		var mesh_instance := MeshInstance3D.new()
		if is_wide:
			beam.size = Vector3(0.06, size.y, size.z + 0.02)
			mesh_instance.position = Vector3(-size.x / 2.0 + t * size.x, 0, 0)
		else:
			beam.size = Vector3(size.x + 0.02, size.y, 0.06)
			mesh_instance.position = Vector3(0, 0, -size.z / 2.0 + t * size.z)
		mesh_instance.mesh = beam
		mesh_instance.material_override = beam_mat
		body.add_child(mesh_instance)

func _build_roof() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = roof_color
	mat.roughness = 0.95

	var roof := BoxMesh.new()
	roof.size = Vector3(width + 0.6, 0.2, depth + 0.6)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = roof
	mesh_instance.material_override = mat
	mesh_instance.position = Vector3(0, wall_height + 0.15, 0)
	mesh_instance.rotation_degrees = Vector3(-8, 0, 0)
	add_child(mesh_instance)
