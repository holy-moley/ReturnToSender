extends Control

func showMenu():
	visible = true

func hideMenu():
	visible = false

func onRestartPressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func onQuitButtonPressed():
	get_tree().quit()
