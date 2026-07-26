extends Control
class_name CharacterSelect
## The game's actual entry point (project main scene). Stores the
## player's choice in GameState before handing off to the cottage yard;
## every level's LevelRoot reads that choice to decide which familiar
## scene belongs in the level.

func _on_cat_pressed() -> void:
	_select("Cat")

func _on_snake_pressed() -> void:
	_select("Snake")

func _on_rat_pressed() -> void:
	_select("Rat")

func _on_crow_pressed() -> void:
	_select("Crow")

func _select(familiar_name: String) -> void:
	GameState.selected_familiar = familiar_name
	get_tree().change_scene_to_file("res://scenes/main/CottageHome.tscn")
