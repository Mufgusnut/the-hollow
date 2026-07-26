extends Node
## Minimal regional suspicion meter — proves out the mechanic described in
## GDD.md "Suspicion / Reputation System" with a single shared value before
## it's tracked per-region and wired to every NPC. Villager.gd is the only
## caller for now.

signal changed(value: float)

var current: float = 0.0

func notice(rate: float, ceiling: float, delta: float) -> void:
	current = min(ceiling, current + rate * delta)
	changed.emit(current)

func decay(rate: float, floor_value: float, delta: float) -> void:
	current = max(floor_value, current - rate * delta)
	changed.emit(current)
