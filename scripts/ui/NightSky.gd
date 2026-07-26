extends Control
class_name NightSky
## Procedurally draws the title screen's night backdrop — stars, a
## crescent moon, and a few soft clouds — entirely via _draw(), since
## there's no art pipeline for this project to import images through.
## Regenerates on resize so it always fills whatever window size the
## game is running at.

@export var star_count: int = 140
@export var moon_radius: float = 70.0
@export var sky_color: Color = Color(0.05, 0.05, 0.1, 1)

var _stars: Array = []
var _moon_position: Vector2
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.seed = 7
	resized.connect(_on_resized)
	_on_resized()

func _on_resized() -> void:
	_generate_stars()
	_moon_position = Vector2(size.x * 0.78, size.y * 0.2)
	queue_redraw()

func _generate_stars() -> void:
	_stars.clear()
	for i in range(star_count):
		_stars.append({
			"pos": Vector2(_rng.randf_range(0, size.x), _rng.randf_range(0, size.y * 0.8)),
			"radius": _rng.randf_range(0.8, 2.2),
			"brightness": _rng.randf_range(0.5, 1.0),
		})

func _draw() -> void:
	for star in _stars:
		draw_circle(star["pos"], star["radius"], Color(1, 1, 0.95, star["brightness"]))

	_draw_moon()
	_draw_cloud(Vector2(size.x * 0.18, size.y * 0.38), 1.0, 0.16)
	_draw_cloud(Vector2(size.x * 0.55, size.y * 0.52), 0.8, 0.13)
	_draw_cloud(Vector2(size.x * 0.32, size.y * 0.63), 0.7, 0.11)

func _draw_moon() -> void:
	draw_circle(_moon_position, moon_radius, Color(0.95, 0.93, 0.82, 1))
	var shadow_offset := Vector2(moon_radius * 0.55, -moon_radius * 0.15)
	draw_circle(_moon_position + shadow_offset, moon_radius * 1.05, sky_color)

func _draw_cloud(center: Vector2, scale_factor: float, alpha: float) -> void:
	var color := Color(1, 1, 1, alpha)
	var puffs := [Vector2(-40, 0), Vector2(-15, -10), Vector2(15, -8), Vector2(45, 2), Vector2(0, 6)]
	for offset in puffs:
		draw_circle(center + offset * scale_factor, 28 * scale_factor, color)
