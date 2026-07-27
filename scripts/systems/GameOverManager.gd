extends CanvasLayer
## Autoload. Any catch source (PatrolVillager.gd, SimpleBuilding.gd's
## trespass zone) calls trigger_game_over() — it decides on its own
## whether that actually matters right now, so callers don't each need
## to check quest_stage themselves. Being caught while carrying the
## potion means whoever caught you finds it and knows exactly whose
## work it is, so the errand is blown: quest resets to "none" (the
## witch has to brew another and re-cast the charm) and the player
## restarts at the cottage.

@onready var _panel: Panel = $Panel
@onready var _label: Label = $Panel/Label

var _triggered: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_panel.visible = false

func trigger_game_over() -> void:
	if _triggered or GameState.quest_stage != "potion_assigned":
		return
	_triggered = true
	_panel.visible = true
	get_tree().paused = true
	GameState.quest_stage = "none"
	await get_tree().create_timer(2.5).timeout
	get_tree().paused = false
	_panel.visible = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main/CottageHome.tscn")
	_triggered = false
