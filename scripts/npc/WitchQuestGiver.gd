extends InteractableNPC
class_name WitchQuestGiver
## Act 1's inciting errand: the village is already turning on the
## witch (a plague, a dead child, whispered blame) and witch hunters
## are already in town, unbeknownst to her — she just knows she can't
## be seen there herself. So she lays a *temporary* brilliance charm on
## the familiar to carry a healing draught to a second dying child in
## her stead. What she says changes with GameState.quest_stage so the
## conversation reads correctly whether you've just been charmed,
## you're mid-errand, or you've already made it back.

func _get_speaker_name() -> String:
	return "The Witch"

func _get_lines() -> Array[String]:
	match GameState.quest_stage:
		"none":
			GameState.quest_stage = "potion_assigned"
			return [
				"Listen to me carefully — there isn't much time.",
				"A child in the village is dying. I've brewed the last of my healing draughts, but I dare not set foot past that door. Not since they started saying my name in the same breath as sickness and graves.",
				"So I've done something I swore I wouldn't. A brilliance charm — just for now. Enough wit to walk with purpose, and to carry what I can't.",
				"Take this to the square. Be quick, be quiet — and don't let anyone see you do anything a creature like you shouldn't be able to do.",
				"If they so much as suspect magic walked through that village today, they'll know exactly whose door to come knocking on.",
				"Come home safe, and I'll lift the charm the moment you're through that door.",
			]
		"potion_assigned":
			return ["Go on — every moment we talk is a moment that child doesn't have."]
		"potion_delivered":
			return ["You're back. And safe. Thank every star for that.", "Rest now — you've done more for that family tonight than you know."]
		_:
			return ["..."]
