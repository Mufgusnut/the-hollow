extends Node
class_name SpellCaster
## Casts the familiar's currently known spells. Mouse play can click an
## interactable prop directly (see FamiliarController._handle_click,
## which tries a cast first and falls back to move-to-point); the
## explicit cast_spell action (right click / controller face button)
## targets whatever's nearest in the sibling "InteractArea" node, which
## is what keyboard and controller play rely on.

signal spell_learned(spell_id: StringName)
signal spell_cast(spell_id: StringName, target: Node)

## Empty by default — spells are meant to be found as tome pages
## (see TomePage.gd), not handed to the player at spawn.
@export var known_spells: Array[StringName] = []
@export var cast_range: float = 3.0

var active_spell: StringName = &"telekinesis"

@onready var _owner_body: Node3D = get_parent()
@onready var _detector: Area3D = get_node_or_null("../InteractArea")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cast_spell"):
		var target := _nearest_in_range(active_spell)
		if target:
			cast_on(target)

func learn_spell(spell_id: StringName) -> void:
	if not known_spells.has(spell_id):
		known_spells.append(spell_id)
		spell_learned.emit(spell_id)

func knows(spell_id: StringName) -> bool:
	return known_spells.has(spell_id)

func cast_on(target: Node) -> bool:
	if not knows(active_spell) or not _supports(target, active_spell):
		return false
	match active_spell:
		&"telekinesis":
			target.apply_telekinesis(_owner_body.global_position)
	spell_cast.emit(active_spell, target)
	return true

func _supports(node: Node, spell_id: StringName) -> bool:
	match spell_id:
		&"telekinesis":
			return node.has_method("apply_telekinesis")
	return false

func _nearest_in_range(spell_id: StringName) -> Node:
	if _detector == null:
		return null
	var best: Node = null
	var best_dist := INF
	for body in _detector.get_overlapping_bodies():
		if not _supports(body, spell_id):
			continue
		var dist := _owner_body.global_position.distance_to(body.global_position)
		if dist < best_dist:
			best_dist = dist
			best = body
	return best
