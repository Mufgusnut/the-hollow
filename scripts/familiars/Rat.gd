extends FamiliarController
class_name Rat
## The Rat familiar: smallest and quickest, mostly beneath notice —
## the stealthiest of the four (lowest suspicion_when_exposed, the
## PatrolVillager.gd notice-meter fill-rate multiplier). Only a small
## hop of a jump, but can burrow into soft garden ground to disappear
## entirely (see HidingSpot.gd). Getting touched, though, draws an
## outsized "kill it" reflex rather than a calm swat — see
## PatrolVillager.gd's TouchZone handling.

func _ready() -> void:
	super._ready()
	move_speed = 6.0
	acceleration = 20.0
	jump_velocity = 3.0
	suspicion_baseline = 0.1
	suspicion_when_exposed = 0.3
