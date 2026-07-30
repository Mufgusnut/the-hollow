extends LevelRoot
class_name CottageUpstairsLevel
## Swaps which version of the witch is actually in the room: the living
## quest-giver until the raid (see CottageHome.gd), WitchBody at the
## mirror once GameState.quest_stage reaches "witch_dead". Both nodes
## are authored in the scene; this just frees whichever doesn't apply
## rather than merely hiding it, so there's no stray InteractZone left
## behind for the wrong one.

func _ready() -> void:
	super._ready()

	var living := get_node_or_null("Witch")
	var body := get_node_or_null("WitchBody")
	if GameState.quest_stage == "witch_dead":
		if living:
			living.queue_free()
	else:
		if body:
			body.queue_free()
