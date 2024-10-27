extends Control
var startPressed = false
func _process(delta: float) -> void:
	if not startPressed:
		get_tree().paused=true

func _on_start_pressed() -> void:
	visible = false
	startPressed=true
	get_tree().paused=false


func _on_quit_pressed() -> void:
	get_tree().quit()
