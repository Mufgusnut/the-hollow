extends Node3D
class_name ForestBorder
## Scatters trees/pines/bushes around a rectangular perimeter so players
## can't wander off the map edge — reads as a forest wall instead of an
## invisible barrier. gap_center/gap_radius leaves one clearing open
## (for a path in/out) that the scatter won't fill.

@export var half_width: float = 12.0
@export var half_depth: float = 12.0
@export var inset: float = 1.0
@export var spacing: float = 1.1
@export var jitter: float = 0.35
@export var tree_scene: PackedScene
@export var pine_scene: PackedScene
@export var bush_scene: PackedScene
@export var seed_value: int = 1
## World-space XZ point to leave clear of scatter (e.g. a path exit).
@export var gap_center: Vector2 = Vector2(9999, 9999)
@export var gap_radius: float = 0.0

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	var x0 := -(half_width - inset)
	var x1 := half_width - inset
	var z0 := -(half_depth - inset)
	var z1 := half_depth - inset

	_scatter_edge(rng, Vector3(x0, 0, z0), Vector3(1, 0, 0), x1 - x0)
	_scatter_edge(rng, Vector3(x0, 0, z1), Vector3(1, 0, 0), x1 - x0)
	_scatter_edge(rng, Vector3(x0, 0, z0), Vector3(0, 0, 1), z1 - z0)
	_scatter_edge(rng, Vector3(x1, 0, z0), Vector3(0, 0, 1), z1 - z0)

func _scatter_edge(rng: RandomNumberGenerator, start: Vector3, dir: Vector3, length: float) -> void:
	var count := int(length / spacing)
	for i in range(count + 1):
		var pos := start + dir * (i * spacing)
		pos.x += rng.randf_range(-jitter, jitter)
		pos.z += rng.randf_range(-jitter, jitter)
		if gap_radius > 0.0 and Vector2(pos.x, pos.z).distance_to(gap_center) < gap_radius:
			continue
		_place_random(rng, pos)

func _place_random(rng: RandomNumberGenerator, pos: Vector3) -> void:
	var roll := rng.randf()
	var scene: PackedScene
	if roll < 0.4:
		scene = tree_scene
	elif roll < 0.75:
		scene = pine_scene
	else:
		scene = bush_scene
	if scene == null:
		return

	var instance := scene.instantiate()
	add_child(instance)
	instance.position = pos
	instance.rotation.y = rng.randf_range(0, TAU)
	var s := rng.randf_range(0.85, 1.2)
	instance.scale = Vector3(s, s, s)
