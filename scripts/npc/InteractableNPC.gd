extends StaticBody3D
class_name InteractableNPC
## Base for any NPC that opens dialogue on "interact" while the
## familiar is nearby. Attach to the NPC's root body; expects a child
## Area3D named "InteractZone" for the detection radius. Subclasses
## override _get_speaker_name()/_get_lines() to decide what to say —
## and what quest state to change — each time they're talked to.

@onready var _zone: Area3D = get_node_or_null("InteractZone")

var _nearby: FamiliarController = null

func _ready() -> void:
	if _zone:
		_zone.body_entered.connect(_on_body_entered)
		_zone.body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	if _nearby and event.is_action_pressed("interact"):
		_talk()

func _on_body_entered(body: Node3D) -> void:
	if body is FamiliarController:
		_nearby = body

func _on_body_exited(body: Node3D) -> void:
	if body == _nearby:
		_nearby = null

func _talk() -> void:
	DialogueManager.start_dialogue(_get_speaker_name(), _get_lines())
	get_viewport().set_input_as_handled()

func _get_speaker_name() -> String:
	return "???"

func _get_lines() -> Array[String]:
	return []
