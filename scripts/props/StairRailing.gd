extends Node3D
class_name StairRailing
## Procedurally places baluster posts climbing alongside a straight
## stair run (see StairBlocks.gd for the matching steps). The top
## handrail itself is a single angled box authored in the scene,
## sharing the ramp's rotation, since one box needs no procedural help.

@export var post_count: int = 6
@export var total_rise: float = 1.6
@export var total_run: float = 4.0
@export var post_height: float = 0.85
@export var post_radius: float = 0.03
@export var run_direction: Vector3 = Vector3(0, 0, 1)
@export var wood_color: Color = Color(0.3, 0.2, 0.13)

func _ready() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = wood_color
	material.roughness = 0.8

	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius = post_radius
	post_mesh.bottom_radius = post_radius
	post_mesh.height = post_height

	var dir := run_direction.normalized()
	for i in range(post_count):
		var t := (i + 0.5) / float(post_count)
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = post_mesh
		mesh_instance.material_override = material
		var base_height := total_rise * t
		mesh_instance.position = dir * (total_run * t) + Vector3(0, base_height + post_height / 2.0, 0)
		add_child(mesh_instance)
