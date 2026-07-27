extends Area3D
class_name HidingSpot
## A tree/well/crack the right familiar species can duck into to
## become unnoticeable to patrolling villagers (see PatrolVillager.gd
## and GameState.is_hidden). Which species qualifies is set per
## instance — trees are Crow-only, the well is Snake-only.

@export var allowed_familiar: String = "Crow"

func _ready() -> void:
	body_entered.connect(_on_entered)
	body_exited.connect(_on_exited)

func _on_entered(body: Node3D) -> void:
	if body is FamiliarController and GameState.selected_familiar == allowed_familiar:
		GameState.is_hidden = true

func _on_exited(body: Node3D) -> void:
	if body is FamiliarController and GameState.selected_familiar == allowed_familiar:
		GameState.is_hidden = false
