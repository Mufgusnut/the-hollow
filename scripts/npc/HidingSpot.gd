extends Area3D
class_name HidingSpot
## A tree/well/soft patch/crack the right familiar species can duck
## into to become unnoticeable to patrolling villagers (see
## PatrolVillager.gd and GameState.is_hidden). Which species qualify is
## set per instance — trees are Crow (perches in the foliage) and Cat
## (climbs up), the well is Snake-only (squeezes into the tight dark
## space), soft garden patches are Rat-only (burrows in).

@export var allowed_familiars: Array[String] = ["Crow"]

func _ready() -> void:
	body_entered.connect(_on_entered)
	body_exited.connect(_on_exited)

func _on_entered(body: Node3D) -> void:
	if body is FamiliarController and GameState.selected_familiar in allowed_familiars:
		GameState.is_hidden = true

func _on_exited(body: Node3D) -> void:
	if body is FamiliarController and GameState.selected_familiar in allowed_familiars:
		GameState.is_hidden = false
