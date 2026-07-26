extends Node3D
class_name StairBlocks
## Procedurally builds a solid stair-block visual (each step a solid
## carved-looking wood block, no gaps between them) along a straight
## run starting at this node's own position. Purely cosmetic — a
## separate invisible ramp (sibling StaticBody3D) matching this same
## run/rise handles the actual walkable collision.

@export var step_count: int = 6
@export var total_rise: float = 1.6
@export var total_run: float = 4.0
@export var step_width: float = 1.1
## Direction the stairs ascend, in this node's local XZ plane.
@export var run_direction: Vector3 = Vector3(0, 0, 1)
@export var wood_color: Color = Color(0.4, 0.28, 0.18)

func _ready() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = wood_color
	material.roughness = 0.85

	var dir := run_direction.normalized()
	var step_rise := total_rise / float(step_count)
	var step_run := total_run / float(step_count)

	for i in range(step_count):
		var height := step_rise * (i + 1)
		var box := BoxMesh.new()
		box.size = Vector3(step_width, height, step_run)
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = box
		mesh_instance.material_override = material
		var center_dist := step_run * (i + 0.5)
		mesh_instance.position = dir * center_dist + Vector3(0, height / 2.0, 0)
		add_child(mesh_instance)
