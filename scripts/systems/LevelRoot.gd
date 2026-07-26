extends Node3D
class_name LevelRoot
## Attach to every level's root node. Two jobs, deliberately split
## across the two points where each is actually safe to do:
##
## _enter_tree() fires top-down — this node before any of its children
## — so it's the only place we can swap the scene's placeholder "Cat"
## node for whichever familiar GameState.selected_familiar says the
## player actually picked, *before* anything else (like CameraRig)
## resolves a reference to the placeholder. Doing this in _ready()
## instead would be too late: children ready bottom-up, so by the time
## this node's _ready() ran, CameraRig would already be holding a
## reference to a node we're about to free.
##
## _ready() then repositions the (possibly swapped) familiar to a
## pending spawn marker and restores its spells. That has to wait
## until _ready() because it needs the familiar's own @onready state
## (spell_caster) to exist, which is only true once the familiar's own
## _ready() has already run.

@export var familiar_path: NodePath = ^"Cat"

const FAMILIAR_SCENES := {
	"Cat": preload("res://scenes/familiars/Cat.tscn"),
	"Snake": preload("res://scenes/familiars/Snake.tscn"),
	"Rat": preload("res://scenes/familiars/Rat.tscn"),
	"Crow": preload("res://scenes/familiars/Crow.tscn"),
}

func _enter_tree() -> void:
	var placeholder := get_node_or_null(familiar_path)
	if placeholder == null:
		return
	var selected: String = GameState.selected_familiar
	if selected == "" or selected == "Cat" or not FAMILIAR_SCENES.has(selected):
		return
	_swap_familiar(placeholder, FAMILIAR_SCENES[selected])

func _swap_familiar(old_familiar: Node, new_scene: PackedScene) -> void:
	var new_instance := new_scene.instantiate()
	new_instance.name = old_familiar.name

	var parent := old_familiar.get_parent()
	var idx := old_familiar.get_index()
	var pos: Vector3 = old_familiar.position
	var rot: Vector3 = old_familiar.rotation

	parent.remove_child(old_familiar)
	old_familiar.queue_free()

	parent.add_child(new_instance)
	parent.move_child(new_instance, idx)
	new_instance.position = pos
	new_instance.rotation = rot

func _ready() -> void:
	var familiar := get_node_or_null(familiar_path) as FamiliarController
	if familiar == null:
		return

	if GameState.pending_spawn_marker != &"":
		var marker := find_child(String(GameState.pending_spawn_marker), true, false) as Node3D
		if marker:
			familiar.teleport_to(marker.global_position, marker.rotation.y)
		GameState.pending_spawn_marker = &""

	if familiar.spell_caster:
		GameState.apply_to(familiar.spell_caster)
