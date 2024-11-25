extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _ready():
	pass # Replace with function body.


func _on_back_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.saveGameSettings()
	queue_free()
