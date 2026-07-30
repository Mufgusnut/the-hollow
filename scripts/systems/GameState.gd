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

## Zone-transition cooldown: LevelRoot.gd stamps this the instant a new
## scene finishes loading; SceneDoor.gd refuses to fire again until it
## elapses. Without it, a spawn marker placed near (or on) the door you
## just walked in through can immediately retrigger the same door back,
## or a player can ping-pong two adjacent doors in quick succession.
const ZONE_TRANSITION_LOCK_SEC: float = 0.5
## Same zone-entry timestamp also backs a longer catch grace period (see
## is_catch_grace_active): stepping out of the witch's cottage and
## straight into a patrol's notice radius, with no time to read its
## route first, felt like getting caught for existing rather than for
## a mistake. A few seconds of immunity right after a scene loads gives
## the player a fair look at the patrol pattern before it can end the
## errand.
const CATCH_GRACE_SEC: float = 3.0
var _zone_entered_at_msec: int = 0

func mark_zone_entered() -> void:
	_zone_entered_at_msec = Time.get_ticks_msec()

func can_use_scene_door() -> bool:
	return Time.get_ticks_msec() - _zone_entered_at_msec >= ZONE_TRANSITION_LOCK_SEC * 1000

func is_catch_grace_active() -> bool:
	return Time.get_ticks_msec() - _zone_entered_at_msec < CATCH_GRACE_SEC * 1000

func capture_from(caster: SpellCaster) -> void:
	known_spells = caster.known_spells.duplicate()

func apply_to(caster: SpellCaster) -> void:
	caster.known_spells = known_spells.duplicate()
