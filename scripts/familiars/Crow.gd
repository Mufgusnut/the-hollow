extends FamiliarController
class_name Crow
## The Crow familiar: takes to the air over ground obstacles, but reads
## as an omen of death to superstitious townsfolk and is loud on
## approach — the least stealthy of the four (highest
## suspicion_when_exposed, the PatrolVillager.gd notice-meter fill-rate
## multiplier). Real sustained flight isn't built; a modest single jump
## plus a real second jump in midair (max_air_jumps) stands in for
## "can basically get onto anything."

func _ready() -> void:
	super._ready()
	move_speed = 4.5
	acceleration = 14.0
	jump_velocity = 4.5
	max_air_jumps = 1
	suspicion_baseline = 0.5
	suspicion_when_exposed = 1.0
