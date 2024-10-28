extends Control

func showMenu():
	visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()
