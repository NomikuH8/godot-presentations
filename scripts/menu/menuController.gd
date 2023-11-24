extends Control

@export var menuScene: PackedScene

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(menuScene)


func _on_exit_button_pressed():
	get_tree().quit()
