extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _ready():
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/baseMenu.visible = true
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/playMenu.visible = false


func _on_play_pressed():
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/baseMenu.visible = false
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/playMenu.visible = true
	$"/root/AudioManager/UI/selectButton".play(0)


func _on_options_pressed():
	sceneManager.switchScene("options")
	$"/root/AudioManager/UI/selectButton".play(0)


func _on_exit_pressed():
	get_tree().quit()



func _on_continue_pressed():
	if FileAccess.file_exists("user://OctopodAnnihilationSaveFile.save"):
		sceneManager.loadGameData()
		sceneManager.switchScene(sceneManager.level)
		$"/root/AudioManager/UI/selectButton".play(0)


func _on_new_pressed():
	sceneManager.switchScene("characterSelection")
	$"/root/AudioManager/UI/selectButton".play(0)


func _on_back_pressed():
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/baseMenu.visible = true
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/playMenu.visible = false
	$"/root/AudioManager/UI/selectButton".play(0)


func _on_scoreboard_pressed():
	sceneManager.switchScene("scoreboard")
	$"/root/AudioManager/UI/selectButton".play(0)
