extends LevelRoot
class_name CottageHomeLevel
## CottageHome's two story hooks on top of normal LevelRoot behavior:
##
## 1. Arriving with quest_stage == "potion_delivered" means the player
##    just got back from town and hasn't seen the raid yet — redirect
##    straight to RaidCutscene before the level (or the still-living
##    Witch upstairs) ever renders, rather than requiring a second trip
##    back through the door.
## 2. Arriving with quest_stage == "raid_aftermath" (set by
##    RaidCutscene.gd right before the handoff) means this is the
##    moment right after: the player should see the three hunters
##    retreat into the forest with no control, then get control back
##    once they're gone. Runs once — advancing to "witch_dead" is what
##    prevents it firing again on a later visit.
## 3. Arriving at the true beginning (quest_stage == "none") plays a
##    one-time tutorial for whichever familiar was picked at
##    CharacterSelect, voiced as the Witch (she's alive and present at
##    this point in the story) — see GameState.tutorials_seen.

const WITCH_HUNTER_SCENE := preload("res://scenes/props/WitchHunter.tscn")

const HUNTER_START_OFFSETS: Array[Vector3] = [
	Vector3(-0.6, 0, -2.0),
	Vector3(0.0, 0, -2.4),
	Vector3(0.6, 0, -2.0),
]
const HUNTER_EXIT_OFFSET := Vector3(-9.5, 0, -2.5)
const HUNTER_WALK_SECONDS: float = 4.5

func _ready() -> void:
	if GameState.quest_stage == "potion_delivered":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/RaidCutscene.tscn")
		return

	super._ready()

	if GameState.quest_stage == "raid_aftermath":
		_play_hunters_leaving()
	elif GameState.quest_stage == "none":
		_maybe_play_tutorial()

func _play_hunters_leaving() -> void:
	var familiar := get_node_or_null(familiar_path) as FamiliarController
	if familiar:
		familiar.input_locked = true

	for start_offset in HUNTER_START_OFFSETS:
		var hunter := WITCH_HUNTER_SCENE.instantiate() as Node3D
		add_child(hunter)
		hunter.position = start_offset
		hunter.look_at(hunter.position + HUNTER_EXIT_OFFSET, Vector3.UP)
		var tween := create_tween()
		tween.tween_property(hunter, "position", HUNTER_EXIT_OFFSET + Vector3(start_offset.x * 0.3, 0, 0), HUNTER_WALK_SECONDS)
		tween.tween_callback(hunter.queue_free)

	await get_tree().create_timer(HUNTER_WALK_SECONDS).timeout

	if familiar:
		familiar.input_locked = false
	GameState.quest_stage = "witch_dead"

func _maybe_play_tutorial() -> void:
	var species: String = GameState.selected_familiar
	if GameState.tutorials_seen.get(species, false):
		return
	var lines := _tutorial_lines_for(species)
	if lines.is_empty():
		return
	GameState.tutorials_seen[species] = true
	DialogueManager.start_dialogue("The Witch", lines)

## One-time briefing per familiar: where it sits in the stealth ranking
## (see Suspicion.gd/PatrolVillager.gd), its jump/movement quirk, its
## unique hide-trick (see HidingSpot.gd), and its touch-reaction nuance.
func _tutorial_lines_for(species: String) -> Array[String]:
	match species:
		"Cat":
			return [
				"Quick and quiet, you are — the best climber of the four, and no tree in this village you couldn't scale.",
				"Should someone catch sight of you out in the open, don't fret. A cat underfoot is nothing strange to them — they'll only think twice if you're carrying something you shouldn't.",
				"Mind the stealth meter all the same. Linger too long in watching eyes and even a common cat draws notice eventually.",
				"And you jump higher than any of your kin. Use it.",
			]
		"Crow":
			return [
				"Loudest of the four, little one — wings and caws carry further than any footstep. Folk will mark you quicker than the others, so mind how fast that stealth meter climbs.",
				"But nothing is truly out of your reach. Hop once, then again in the air, and you'll land where paws and scales never could.",
			]
		"Rat":
			return [
				"Smallest and quietest of the four — hardly a soul looks twice at vermin, and the stealth meter barely stirs on your account.",
				"But should a hand actually close on you, the fright of it turns heads far and wide. Don't count on the gentle mercy your feline kin gets.",
				"Dig into soft, turned earth and you'll vanish from sight entirely — a garden patch will hide you as well as any burrow.",
				"Only the smallest hop in you, but you'll rarely need more.",
			]
		"Snake":
			return [
				"Of the four, you unsettle folk worst of all — a snake underfoot sends them reeling, and word travels fast. Your stealth is thin, better only than the crow's.",
				"Yet no gap is too narrow for you. The old well down in the square will hide you deeper than any tree could.",
				"You've no legs for jumping — you slither, not leap. Find your way around, not over.",
			]
		_:
			return []
