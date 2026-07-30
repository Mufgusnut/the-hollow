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
