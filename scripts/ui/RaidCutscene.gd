extends Control
class_name RaidCutscene
## Plays the witch-hunter raid/death cutscene, triggered by CottageHome
## when the player arrives with quest_stage == "potion_delivered" (see
## CottageHome.gd). Any key/click/controller press skips straight
## through, same courtesy as IntroVideo. On finish, hands off to
## CottageHome in the "raid_aftermath" state, spawning the familiar
## outside to watch the hunters leave (see CottageHome.gd
## _play_hunters_leaving) rather than dropping back into free play.
##
## Skip input is ignored for the first SKIP_DELAY_SEC — see IntroVideo.gd
## for why (a bare "any key" skip was too easy to trigger by accident).

const SKIP_DELAY_SEC: float = 2.0

@onready var _player: VideoStreamPlayer = $VideoStreamPlayer

var _advancing: bool = false
var _elapsed_sec: float = 0.0

func _ready() -> void:
	_player.finished.connect(_advance)
	if _player.stream:
		_player.play()
	else:
		_advance()

func _process(delta: float) -> void:
	_elapsed_sec += delta

func _unhandled_input(event: InputEvent) -> void:
	if _advancing or _elapsed_sec < SKIP_DELAY_SEC:
		return
	if (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton) and event.pressed:
		_advance()

func _advance() -> void:
	if _advancing:
		return
	_advancing = true
	GameState.quest_stage = "raid_aftermath"
	GameState.pending_spawn_marker = &"SpawnPostRaid"
	## Deferred: see IntroVideo.gd for why (can fire from _ready() itself,
	## and change_scene_to_file() during the tree's own setup throws
	## "Parent node is busy adding/removing children").
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main/CottageHome.tscn")
