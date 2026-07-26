extends Area3D
class_name HiddenCompartment
## A loose floorboard / false-bottom drawer that looks like ordinary
## furniture until searched. Pressing "interact" while the familiar is
## in range pops its lid open and spawns reveal_scene (typically a
## TomePage) beside it — a second discovery step on top of the usual
## walk-into-it pickups, meant for things placed for players who
## actually search the room rather than just pass through it.

@export var reveal_scene: PackedScene
@export var reveal_offset: Vector3 = Vector3(0, 0.3, 0.35)

@onready var _lid: Node3D = get_node_or_null("Lid")

var _opened: bool = false
var _nearby: FamiliarController = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	if _opened or _nearby == null:
		return
	if event.is_action_pressed("interact"):
		_open()

func _on_body_entered(body: Node3D) -> void:
	if body is FamiliarController:
		_nearby = body

func _on_body_exited(body: Node3D) -> void:
	if body == _nearby:
		_nearby = null

func _open() -> void:
	_opened = true
	if _lid:
		var tween := create_tween()
		tween.tween_property(_lid, "rotation_degrees:x", -110, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if reveal_scene:
		var reward := reveal_scene.instantiate()
		get_parent().add_child(reward)
		reward.global_position = global_position + reveal_offset
