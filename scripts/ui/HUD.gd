extends CanvasLayer
## Always-on stealth meter for the village errand (autoload, same
## CanvasLayer pattern as DialogueManager/GameOverManager). Listens to
## Suspicion.gd's `changed` signal — see PatrolVillager.gd/Suspicion.gd
## for how the meter actually fills (a NoticeZone watching the active,
## non-hidden familiar) and decays (clear of every notice zone). Sits
## quietly at zero outside the stealth errand; harmless to leave
## visible everywhere rather than showing/hiding it per-scene.

@onready var _bar: ProgressBar = $StealthMeter
var _fill_style: StyleBoxFlat

func _ready() -> void:
	_bar.max_value = Suspicion.CEILING
	_bar.value = Suspicion.current
	_fill_style = _bar.get_theme_stylebox("fill").duplicate()
	_bar.add_theme_stylebox_override("fill", _fill_style)
	_update_fill_color(Suspicion.current)
	Suspicion.changed.connect(_on_suspicion_changed)

func _on_suspicion_changed(value: float) -> void:
	_bar.value = value
	_update_fill_color(value)

func _update_fill_color(value: float) -> void:
	var ratio := clampf(value / Suspicion.CEILING, 0.0, 1.0)
	_fill_style.bg_color = Color(0.25, 0.75, 0.3).lerp(Color(0.85, 0.15, 0.15), ratio)
