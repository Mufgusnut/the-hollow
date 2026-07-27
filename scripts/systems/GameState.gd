extends Node
## Tiny persistence layer that survives change_scene_to_file calls —
## without it, walking through a door (which tears down and rebuilds
## the whole scene tree, familiar included) would silently reset any
## spells the player had already learned. SceneDoor.gd writes to this
## right before a transition; LevelRoot.gd reads it right after.

var known_spells: Array[StringName] = []
var pending_spawn_marker: StringName = &""
## Set by CharacterSelect.gd before the game ever loads a level; every
## level's LevelRoot reads this to decide which familiar scene actually
## belongs at its placeholder "Cat" node. "Cat" is the default so any
## scene can still be opened directly (e.g. for testing) without going
## through character select first.
var selected_familiar: String = "Cat"
## Tracks the healing-draught errand across scenes: "none" ->
## "potion_assigned" (after talking to the witch) -> "potion_delivered"
## (after talking to Mira in town). A plain string rather than a quest
## framework since there's exactly one quest right now.
var quest_stage: String = "none"
## True while the active familiar is standing in a HidingSpot (a tree
## for Crow, the well for Snake) — PatrolVillager.gd's wide notice
## radius ignores the familiar while this is set.
var is_hidden: bool = false

func capture_from(caster: SpellCaster) -> void:
	known_spells = caster.known_spells.duplicate()

func apply_to(caster: SpellCaster) -> void:
	caster.known_spells = known_spells.duplicate()
