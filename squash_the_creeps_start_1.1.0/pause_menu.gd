extends Control


var isPaused:bool = false:
	set(val): 
		isPaused = val
		get_tree().paused = isPaused
		visible = isPaused
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): 
		#If it's paused, it resumes. Resume button not the only way to return to game. 
		isPaused = !isPaused


func _on_resume_button_pressed() -> void:
	isPaused = false


func _on_respawn_button_pressed() -> void:
	isPaused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
 
