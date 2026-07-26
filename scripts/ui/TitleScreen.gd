extends Control
class_name TitleScreen
## The game's true entry point (project main scene) — starry backdrop,
## title, and a "press any key" prompt that hands off to character
## select.

@onready var _prompt: Label = $PromptLabel
@onready var _music: AudioStreamPlayer = $Music

var _t: float = 0.0
var _advancing: bool = false

func _ready() -> void:
	## Looping via the finished signal rather than the stream's own loop
	## flag — that flag lives in Intro.mp3's .import metadata, which
	## only exists once the editor has imported the file, so this is
	## the reliable option from a hand-authored scene.
	_music.finished.connect(_music.play)

func _process(delta: float) -> void:
	_t += delta * 2.5
	_prompt.modulate.a = 0.4 + 0.6 * (0.5 + 0.5 * sin(_t))

func _unhandled_input(event: InputEvent) -> void:
	if _advancing:
		return
	if (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton) and event.pressed:
		_advance()

func _advance() -> void:
	_advancing = true
	get_tree().change_scene_to_file("res://scenes/ui/CharacterSelect.tscn")
