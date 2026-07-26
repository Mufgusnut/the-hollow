extends FamiliarController
class_name Rat
## The Rat familiar: smallest and quickest, mostly beneath notice —
## townsfolk barely register vermin, so ambient suspicion runs low.
## Getting spotted up close draws a reflexive swat, not an alarm
## (see GDD.md "Familiar Bias").

func _ready() -> void:
	super._ready()
	move_speed = 6.0
	acceleration = 20.0
	jump_velocity = 4.0
	suspicion_baseline = 0.1
	suspicion_when_exposed = 0.5
