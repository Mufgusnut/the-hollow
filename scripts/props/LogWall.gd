extends Node3D
class_name LogWall
## Renders a wall as a stack of horizontal logs instead of a flat panel,
## for the log-cabin look. Generated at runtime so the house's many
## walls don't need their logs hand-placed node by node — attach to a
## child of a wall's StaticBody3D; the StaticBody3D keeps its own flat
## BoxShape3D for collision, this is visual only.

@export var wall_width: float = 6.0
@export var wall_height: float = 2.6
@export var log_radius: float = 0.15
@export var log_color: Color = Color(0.45, 0.32, 0.18)

func _ready() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = log_color
	material.roughness = 0.9

	var log_mesh := CylinderMesh.new()
	log_mesh.top_radius = log_radius
	log_mesh.bottom_radius = log_radius
	log_mesh.height = wall_width

	var log_count := int(ceil(wall_height / (log_radius * 2.0)))
	var spacing := wall_height / float(log_count)

	for i in range(log_count):
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = log_mesh
		mesh_instance.material_override = material
		mesh_instance.rotation_degrees = Vector3(0, 0, 90)
		mesh_instance.position = Vector3(0, spacing * (i + 0.5) - wall_height / 2.0, 0)
		add_child(mesh_instance)
