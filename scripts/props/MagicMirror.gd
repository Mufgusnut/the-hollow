extends Area3D
class_name MagicMirror
## The witch's scrying mirror — narratively significant, mechanically
## inert for now. Reserved as a hook for later: find it via the
## "magic_mirror" group, or extend this script once there's an actual
## ability/story beat that uses it. Deliberately not building mechanics
## for a feature that doesn't exist yet.

@export var mirror_name: String = "The Scrying Glass"

func _ready() -> void:
	add_to_group("magic_mirror")
