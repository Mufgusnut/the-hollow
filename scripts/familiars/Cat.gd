extends FamiliarController
class_name Cat
## The Cat familiar: fast and quiet. Cats are common enough that ambient
## suspicion runs low, but once townsfolk connect *this* specific cat to
## the witch, suspicion spikes harder than it does for the other
## familiars (see GDD.md "Familiar Bias").

func _ready() -> void:
	super._ready()
	move_speed = 5.0
	acceleration = 16.0
	jump_velocity = 5.5
	suspicion_baseline = 0.2
	suspicion_when_exposed = 0.9
