extends Area3D
class_name SceneDoor
## A doorway trigger: stepping into it saves the familiar's spell
## progress to GameState and swaps the whole scene tree to
## target_scene, landing the familiar at the Marker3D named
## spawn_marker_name in that scene (read by that scene's LevelRoot).

@export var target_scene: String = ""
@export var spawn_marker_name: StringName = &""

var _triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if _triggered or not GameState.can_use_scene_door():
		return
	var familiar := body as FamiliarController
	if familiar == null or target_scene == "":
		return
	_triggered = true
	if familiar.spell_caster:
		GameState.capture_from(familiar.spell_caster)
	GameState.pending_spawn_marker = spawn_marker_name
	get_tree().change_scene_to_file(target_scene)
