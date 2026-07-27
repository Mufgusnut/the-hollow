extends InteractableNPC
class_name PoulticeRecipient
## Mira, mother of the second child the plague is killing — the one
## the witch's healing draught is meant to save. Only actually
## completes the errand if it's been assigned; talking to her before
## that (or again after) just gets a normal line.

func _get_speaker_name() -> String:
	return "Mira"

func _get_lines() -> Array[String]:
	match GameState.quest_stage:
		"potion_assigned":
			GameState.quest_stage = "potion_delivered"
			return [
				"*from inside, a child's cough, wet and ragged*",
				"Oh — thank the stars, thank you. Is that from her? Is that the draught?",
				"Bless her. Bless her for not giving up on us, whatever they're all saying.",
				"Go now, quickly, before someone sees you here.",
			]
		"potion_delivered":
			return ["She's sleeping easier tonight. First time in days."]
		_:
			return ["Lovely day for a walk, isn't it?"]
