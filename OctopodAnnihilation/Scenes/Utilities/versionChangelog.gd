extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _on_button_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("mainMenu")
