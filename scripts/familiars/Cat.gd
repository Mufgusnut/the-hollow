extends FamiliarController
class_name Cat
## The Cat familiar: fast, quiet, and the best jumper of the four —
## can climb any tree (see HidingSpot.gd) as well as hide in one.
## Second-stealthiest at range behind Rat (suspicion_when_exposed is
## the PatrolVillager.gd notice-meter fill-rate multiplier — lower
## fills slower). A cat caught in the open usually just gets petted;
## see PatrolVillager.gd's TouchZone handling for the exception when
## it's actually carrying something it shouldn't.

func _ready() -> void:
	super._ready()
	move_speed = 5.0
	acceleration = 16.0
	jump_velocity = 6.5
	suspicion_baseline = 0.2
	suspicion_when_exposed = 0.5
