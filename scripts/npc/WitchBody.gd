extends InteractableNPC
class_name WitchBody
## What's left at the mirror once quest_stage reaches "witch_dead" (see
## CottageUpstairs.gd, which swaps this in for the living Witch node).
## Interacting just gives the player a moment with it — nothing here
## changes quest_stage; that already happened back in CottageHome.

func _get_speaker_name() -> String:
	return "..."

func _get_lines() -> Array[String]:
	return [
		"She's still warm.",
		"The mirror shows nothing back — not even you.",
	]
