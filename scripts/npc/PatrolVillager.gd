extends CharacterBody3D
class_name PatrolVillager
## A townsfolk NPC that wanders randomly near its home spot on the
## village square — no fixed back-and-forth line, so there's no route
## to memorize during the stealth errand. Occasionally pauses to look
## around, and sometimes stops to "chat" when it happens to end up
## near another villager. Ends the potion errand (see
## GameOverManager.gd) two different ways:
##  - NoticeZone (wide) doesn't catch on its own anymore — entering it
##    increments Suspicion.watcher_count, and Suspicion.gd's own
##    _process() gradually fills the shared HUD meter (rate scaled by
##    the active familiar's suspicion_when_exposed) while any zone is
##    watching a non-hidden familiar, ending the errand only once that
##    meter reaches Suspicion.CEILING. GameState.is_hidden (tree/well/
##    garden HidingSpot.gd) pauses the fill entirely.
##  - TouchZone (tight, right at body contact) is a bigger deal than
##    at-range notice and still catches instantly for every species —
##    except Cat, who's usually just mistaken for a stray and petted,
##    *unless* it's actually carrying the quest item right now.
## Outside the errand this is inert: trigger_game_over() no-ops unless
## GameState.quest_stage == "potion_assigned".

## point_a/point_b are kept as the two authored scene values rather
## than adding new exported fields — reinterpreted as the wander
## line's home center and Z bounds instead of fixed patrol endpoints,
## so the three instances already placed in Village.tscn need no edits.
@export var point_a: Vector3
@export var point_b: Vector3
@export var move_speed: float = 1.6
## How far in X the villager will wander from its home spot. Generous —
## there's open street either side — but Z stays within point_a/b's
## original range: that already sits right at the edge of buildings'
## roof geometry occluding NPCs from the fixed isometric camera (see
## the Mira placement fix), so wandering further toward the buildings
## risks the same near-invisible NPC problem.
@export var wander_x_range: float = 4.0
@export var arrive_distance: float = 0.25
@export var pause_min_sec: float = 1.0
@export var pause_max_sec: float = 2.5
@export var chat_min_sec: float = 2.0
@export var chat_max_sec: float = 4.0
@export var chat_trigger_radius: float = 3.5
@export var chat_chance: float = 0.5

enum State { WANDER, PAUSE, CHAT }

var _state: State = State.PAUSE
var _state_timer: float = 0.0
var _target: Vector3
var _home: Vector3
var _wander_z_min: float
var _wander_z_max: float
var _caught: bool = false
var _rng := RandomNumberGenerator.new()

@onready var _notice_zone: Area3D = $NoticeZone
@onready var _touch_zone: Area3D = $TouchZone

func _ready() -> void:
	_notice_zone.body_entered.connect(_on_notice_entered)
	_notice_zone.body_exited.connect(_on_notice_exited)
	_touch_zone.body_entered.connect(_on_touch_entered)

	_home = Vector3(point_a.x, global_position.y, (point_a.z + point_b.z) / 2.0)
	_wander_z_min = min(point_a.z, point_b.z)
	_wander_z_max = max(point_a.z, point_b.z)

	_rng.randomize()
	add_to_group("patrol_villagers")
	_state_timer = _rng.randf_range(pause_min_sec, pause_max_sec)

func _physics_process(delta: float) -> void:
	match _state:
		State.WANDER:
			_process_wander()
		State.PAUSE, State.CHAT:
			_process_timer(delta)
	move_and_slide()

func _process_wander() -> void:
	var to_target := _target - global_position
	to_target.y = 0.0
	if to_target.length() < arrive_distance:
		velocity = Vector3.ZERO
		_check_for_chat_or_pause()
		return
	velocity = to_target.normalized() * move_speed
	rotation.y = atan2(to_target.x, to_target.z)

func _process_timer(delta: float) -> void:
	velocity = Vector3.ZERO
	_state_timer -= delta
	if _state_timer <= 0.0:
		_begin_wander()

func _check_for_chat_or_pause() -> void:
	var partner := _find_chat_partner()
	if partner and _rng.randf() < chat_chance:
		_start_chat(partner)
	else:
		_state = State.PAUSE
		_state_timer = _rng.randf_range(pause_min_sec, pause_max_sec)

## Only ever finds a partner that's itself free to chat (not already
## mid-conversation with a third villager) — otherwise two could both
## "start" a chat with a partner who immediately wanders off toward
## someone else.
func _find_chat_partner() -> PatrolVillager:
	for node in get_tree().get_nodes_in_group("patrol_villagers"):
		if node == self or not (node is PatrolVillager):
			continue
		var other := node as PatrolVillager
		if other._state == State.CHAT:
			continue
		if global_position.distance_to(other.global_position) <= chat_trigger_radius:
			return other
	return null

func _start_chat(partner: PatrolVillager) -> void:
	var duration := _rng.randf_range(chat_min_sec, chat_max_sec)
	_enter_chat(partner.global_position, duration)
	partner._enter_chat(global_position, duration)

func _enter_chat(look_at_pos: Vector3, duration: float) -> void:
	_state = State.CHAT
	_state_timer = duration
	var to_partner := look_at_pos - global_position
	to_partner.y = 0.0
	if to_partner.length() > 0.01:
		rotation.y = atan2(to_partner.x, to_partner.z)

func _begin_wander() -> void:
	_target = Vector3(
		_home.x + _rng.randf_range(-wander_x_range, wander_x_range),
		_home.y,
		_rng.randf_range(_wander_z_min, _wander_z_max)
	)
	_state = State.WANDER

func _on_notice_entered(body: Node3D) -> void:
	if body is FamiliarController:
		Suspicion.watcher_count += 1

func _on_notice_exited(body: Node3D) -> void:
	if body is FamiliarController:
		Suspicion.watcher_count = max(0, Suspicion.watcher_count - 1)

func _on_touch_entered(body: Node3D) -> void:
	if not (body is FamiliarController):
		return
	if GameState.selected_familiar == "Cat" and GameState.quest_stage != "potion_assigned":
		_pet_the_cat()
		return
	_catch()

## Most folk see a stray cat, not a witch's familiar — unless it's
## actually carrying something incriminating (see the touch-handling
## comment up top), getting spotted up close is harmless.
func _pet_the_cat() -> void:
	DialogueManager.start_dialogue("Villager", ["Aw, hello there, puss."])

func _catch() -> void:
	if _caught:
		return
	_caught = true
	GameOverManager.trigger_game_over()
