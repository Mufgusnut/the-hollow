extends Control
class_name IntroVideo
## Plays the backstory video between the title screen and character
## select. Any key/click/controller press skips straight through —
## standard courtesy for a cutscene, not a punishment for wanting to
## play. If no video has been wired in yet (stream left empty), it
## skips through immediately on its own rather than showing a dead
## black screen, so this scene is safe to sit in the chain even before
## the video file exists.
##
## Skip input is ignored for the first SKIP_DELAY_SEC: a bare "any key"
## skip with no minimum was too easy to trigger by accident (a stray
## keypress mid-transition) and lose the whole cutscene instantly.

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
	## Deferred: _advance() can fire from _ready() itself (no video
	## wired in yet), and change_scene_to_file() during the tree's own
	## setup throws "Parent node is busy adding/removing children."
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/CharacterSelect.tscn")
