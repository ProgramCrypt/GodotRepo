extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _ready():
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/baseMenu.visible = true
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/playMenu.visible = false


func _on_play_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/baseMenu.visible = false
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/playMenu.visible = true


func _on_options_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("options")


func _on_exit_pressed():
	get_tree().quit()



func _on_continue_pressed():
	if FileAccess.file_exists("user://OctopodAnnihilationSaveFile.save"):
		$"/root/AudioManager/UI/selectButton".play(0)
		sceneManager.loadGameData()
		sceneManager.switchScene(sceneManager.level)


func _on_new_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("characterSelection")


func _on_back_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/baseMenu.visible = true
	$mainMenu/VBoxContainer/HBoxContainer2/VBoxContainer/playMenu.visible = false


func _on_scoreboard_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("scoreboard")


func _on_version_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("versionChangelog")
