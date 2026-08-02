extends Node
## The village stealth errand's detection meter — climbs while any
## PatrolVillager.gd NoticeZone is watching the active (non-hidden)
## familiar, decays back down once clear, and ends the errand at
## CEILING. Shown live on HUD.gd. (Villager.gd, an unused Main.tscn
## demo NPC, also calls notice()/decay() directly but isn't reachable
## in real play — this autoload's own _process() below is what drives
## the real game.)
##
## Centralized here rather than each PatrolVillager independently
## calling notice()/decay() every frame: with three patrol villagers
## sharing one global meter, one villager's "not watching, decay" call
## would fight another's "watching, fill" call in the same frame.
## Instead each NoticeZone just increments/decrements watcher_count on
## enter/exit, and _process() below makes the one fill-or-decay
## decision per frame based on whether *any* villager is currently
## watching.

signal changed(value: float)

## Reaching this means "fully detected" — shared by every
## PatrolVillager.gd instance and HUD.gd's max_value so they all agree
## on the same number.
const CEILING: float = 100.0
const BASE_FILL_RATE: float = 25.0
const DECAY_RATE: float = 20.0

var current: float = 0.0
## How many NoticeZones currently have the active familiar in range.
## Zero or more — with three patrol villagers, more than one can be
## watching at once.
var watcher_count: int = 0
## Set by LevelRoot.gd once per level load, once it's resolved which
## familiar scene actually belongs at the placeholder — read here for
## that familiar's suspicion_when_exposed fill-rate multiplier.
var active_familiar: FamiliarController = null

func _process(delta: float) -> void:
	if watcher_count > 0 and active_familiar and not GameState.is_hidden:
		var multiplier := active_familiar.suspicion_when_exposed
		notice(BASE_FILL_RATE * multiplier, CEILING, delta)
		if current >= CEILING:
			GameOverManager.trigger_game_over()
	else:
		decay(DECAY_RATE, 0.0, delta)

func notice(rate: float, ceiling: float, delta: float) -> void:
	current = min(ceiling, current + rate * delta)
	changed.emit(current)

func decay(rate: float, floor_value: float, delta: float) -> void:
	current = max(floor_value, current - rate * delta)
	changed.emit(current)

## Called by LevelRoot.gd on every level load — without this, a meter
## partway full (or a watcher_count left over from a notice zone the
## player was standing in when a SceneDoor fired) would bleed into a
## scene that has nothing to do with the stealth errand.
func reset() -> void:
	current = 0.0
	watcher_count = 0
	changed.emit(current)
