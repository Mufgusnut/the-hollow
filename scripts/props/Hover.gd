extends Node3D
class_name Hover
## Gentle vertical bob for objects that should read as levitating —
## the witch's broom today, potentially other floating magic props
## later. Operates on local position, so it works fine parented under
## a stationary object.

@export var amplitude: float = 0.08
@export var speed: float = 1.5

var _base_y: float
var _t: float = 0.0

func _ready() -> void:
	_base_y = position.y

func _process(delta: float) -> void:
	_t += delta * speed
	position.y = _base_y + sin(_t) * amplitude
