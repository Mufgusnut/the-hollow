extends CanvasLayer
## Global dialogue overlay (autoload, accessed by its autoload name —
## no class_name here, since a class_name matching an autoload's own
## name is a hard parse error in Godot). Any NPC calls start_dialogue()
## with its name and lines; this survives scene changes, which matters
## since the witch's conversation and the delivery conversation happen
## in different scenes. Pauses the tree while active so the world
## freezes during a conversation — this node runs at PROCESS_MODE_ALWAYS
## so it keeps responding to input while everything else is paused.

signal dialogue_finished

var _lines: Array[String] = []
var _index: int = 0
var _active: bool = false

@onready var _panel: Panel = $Panel
@onready var _name_label: Label = $Panel/NameLabel
@onready var _line_label: Label = $Panel/LineLabel
@onready var _hint_label: Label = $Panel/HintLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_panel.visible = false

func start_dialogue(speaker_name: String, lines: Array[String]) -> void:
	if lines.is_empty():
		return
	_lines = lines
	_index = 0
	_active = true
	_name_label.text = speaker_name
	_line_label.text = _lines[0]
	_panel.visible = true
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if not _active:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("click_move"):
		_advance()
		get_viewport().set_input_as_handled()

func _advance() -> void:
	_index += 1
	if _index >= _lines.size():
		_close()
	else:
		_line_label.text = _lines[_index]

func _close() -> void:
	_active = false
	_panel.visible = false
	get_tree().paused = false
	dialogue_finished.emit()
