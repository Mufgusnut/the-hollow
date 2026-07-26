extends FamiliarController
class_name Crow
## The Crow familiar: takes to the air over ground obstacles, but reads
## as an omen of death to superstitious townsfolk — high ambient
## suspicion (see GDD.md "Familiar Bias"). Real flight (sustained,
## player-controlled) isn't built yet; for now a much higher jump
## stands in for "can get over things others can't."

func _ready() -> void:
	super._ready()
	move_speed = 4.5
	acceleration = 14.0
	jump_velocity = 7.5
	suspicion_baseline = 0.5
	suspicion_when_exposed = 0.6
