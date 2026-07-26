extends Area3D
class_name TomePage
## A torn page of the master's spellbook. Touching it teaches the
## familiar the spell it holds — this is how spells are meant to be
## acquired per GDD.md "Magic & Progression"; nothing should be handed
## to the player for free at spawn.

@export var spell_id: StringName = &"telekinesis"

@onready var _visual: Node3D = $Visual

var _collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if _collected:
		return
	_visual.rotation.y += delta * 1.2

func _on_body_entered(body: Node3D) -> void:
	if _collected:
		return
	var familiar := body as FamiliarController
	if familiar == null or familiar.spell_caster == null:
		return
	_collected = true
	familiar.spell_caster.learn_spell(spell_id)
	_play_pickup_and_free()

func _play_pickup_and_free() -> void:
	monitoring = false
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_visual, "scale", Vector3.ZERO, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", position.y + 0.6, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(queue_free)
