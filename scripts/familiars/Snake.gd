extends FamiliarController
class_name Snake
## The Snake familiar: slips through the tightest gaps of any familiar
## (see HidingSpot.gd, the well), but a snake underfoot triggers the
## most severe reaction of any species — see PatrolVillager.gd's
## TouchZone handling. Second-lowest stealth at range, ahead of only
## Crow (suspicion_when_exposed is the notice-meter fill-rate
## multiplier). Can't jump at all; it slithers, it doesn't leap.

func _ready() -> void:
	super._ready()
	move_speed = 3.5
	acceleration = 10.0
	jump_velocity = 0.0
	suspicion_baseline = 0.6
	suspicion_when_exposed = 0.75
