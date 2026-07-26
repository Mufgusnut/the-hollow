extends StaticBody3D
class_name Villager
## Minimal NPC proving the suspicion loop end to end: notices the player
## familiar while it's within NoticeArea, raises the shared Suspicion
## meter toward that familiar's suspicion_when_exposed ceiling, and
## shows the current state as a color so the mechanic is visible before
## there's any UI for it.

@export var notice_rate: float = 0.25
@export var decay_rate: float = 0.1

@onready var _mesh: MeshInstance3D = $MeshInstance3D
@onready var _detector: Area3D = $NoticeArea

var _material: StandardMaterial3D
var _watching: FamiliarController = null

func _ready() -> void:
	_material = StandardMaterial3D.new()
	_mesh.set_surface_override_material(0, _material)
	_detector.body_entered.connect(_on_body_entered)
	_detector.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if _watching:
		Suspicion.notice(notice_rate, _watching.suspicion_when_exposed, delta)
	else:
		Suspicion.decay(decay_rate, 0.0, delta)
	_update_color()

func _on_body_entered(body: Node3D) -> void:
	if body is FamiliarController:
		_watching = body

func _on_body_exited(body: Node3D) -> void:
	if body == _watching:
		_watching = null

func _update_color() -> void:
	var t: float = clamp(Suspicion.current, 0.0, 1.0)
	_material.albedo_color = Color(0.2, 0.8, 0.3).lerp(Color(0.9, 0.15, 0.15), t)
