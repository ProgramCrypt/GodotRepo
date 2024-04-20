extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _on_button_pressed():
	sceneManager.switchScene("mainMenu")
	$"/root/AudioManager/UI/selectButton".play(0)
