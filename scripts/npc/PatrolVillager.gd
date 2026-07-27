extends CharacterBody3D
class_name PatrolVillager
## A townsfolk NPC that walks back and forth between two points across
## the village square. Catching the familiar ends the potion errand
## (see GameOverManager.gd) two different ways:
##  - NoticeZone (wide) fires for species that read as conspicuous at
##    range — Crow, Snake — unless the familiar is currently hidden in
##    a tree/well (GameState.is_hidden, set by HidingSpot.gd).
##  - TouchZone (tight, right at body contact) always fires, for every
##    species — Cat and Rat blend in from a distance but a villager
##    literally bumping into them still notices.
## Outside the errand this is inert: trigger_game_over() no-ops unless
## GameState.quest_stage == "potion_assigned".

@export var point_a: Vector3
@export var point_b: Vector3
@export var move_speed: float = 1.6
## Species this villager never notices from a distance — only a direct
## touch (TouchZone) catches them. Matches Cat/Rat's low suspicion
## baseline from the GDD.
@export var stealthy_species: Array[String] = ["Cat", "Rat"]

var _going_to_b: bool = true
var _caught: bool = false

@onready var _notice_zone: Area3D = $NoticeZone
@onready var _touch_zone: Area3D = $TouchZone

func _ready() -> void:
	_notice_zone.body_entered.connect(_on_notice_entered)
	_touch_zone.body_entered.connect(_on_touch_entered)

func _physics_process(_delta: float) -> void:
	var target := point_b if _going_to_b else point_a
	var to_target := target - global_position
	to_target.y = 0.0
	if to_target.length() < 0.3:
		_going_to_b = not _going_to_b
		return
	velocity = to_target.normalized() * move_speed
	rotation.y = atan2(to_target.x, to_target.z)
	move_and_slide()

func _on_notice_entered(body: Node3D) -> void:
	if not (body is FamiliarController) or GameState.is_hidden:
		return
	if GameState.selected_familiar in stealthy_species:
		return
	_catch()

func _on_touch_entered(body: Node3D) -> void:
	if body is FamiliarController:
		_catch()

func _catch() -> void:
	if _caught:
		return
	_caught = true
	GameOverManager.trigger_game_over()
