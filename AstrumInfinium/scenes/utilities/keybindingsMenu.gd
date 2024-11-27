extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _ready():
	if sceneManager.detectController == true:
		$window/menu/VBoxContainer/back.grab_focus()


func _on_back_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.saveGameSettings()
	queue_free()
