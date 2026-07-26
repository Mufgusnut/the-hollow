extends FamiliarController
class_name Snake
## The Snake familiar: slips through gaps nothing else can, but a
## snake in the house triggers near-universal panic — the steepest
## suspicion curve of any familiar (see GDD.md "Familiar Bias"). Can't
## jump; it slithers, it doesn't leap.

func _ready() -> void:
	super._ready()
	move_speed = 3.5
	acceleration = 10.0
	jump_velocity = 0.0
	suspicion_baseline = 0.6
	suspicion_when_exposed = 0.95
