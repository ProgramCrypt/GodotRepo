extends Control

@onready var sceneManager = get_node("/root/SceneManager")
@onready var gameSettings = get_node("/root/GameSettings")

@export var keybindingsMenu : PackedScene


func _ready():
	$"/root/AudioManager/music/Uranus".play(0)
	
	$MarginContainer/mainMenu/center/mainButtons.visible = true
	$MarginContainer/mainMenu/center/newGameButtons.visible = false
	$MarginContainer/mainMenu/center/optionsVolume.visible = false
	$MarginContainer/mainMenu/center/optionsOther.visible = false
	$MarginContainer/mainMenu/center/creditsLeft.visible = false
	$MarginContainer/mainMenu/center/creditsRight.visible = false
	$MarginContainer/mainMenu/center/version.visible = false
	$MarginContainer/mainMenu/lowerButtons.visible = true
	$MarginContainer/mainMenu/lowerButtons/credits.visible = true
	$MarginContainer/mainMenu/lowerButtons/version.visible = true
	$MarginContainer/mainMenu/lowerButtons/backLower.visible = false
	
	$MarginContainer/mainMenu/center/optionsVolume/masterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$MarginContainer/mainMenu/center/optionsVolume/musicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$MarginContainer/mainMenu/center/optionsVolume/sfxSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	$MarginContainer/mainMenu/center/optionsVolume/voiceSlider.value = db_to_linear(AudioServer.get_bus_volume_db(3))
	$MarginContainer/mainMenu/center/optionsOther/sensitivitySlider.value = gameSettings.cameraSensitivity
	$MarginContainer/mainMenu/center/optionsOther/fovSlider.value = gameSettings.fieldOfView
	
	if sceneManager.maxLvl == 0 and sceneManager.maxCheckpoint == 0:
		$MarginContainer/mainMenu/center/mainButtons/loadGame.disabled = true
	else:
		$MarginContainer/mainMenu/center/mainButtons/loadGame.disabled = false


func _on_new_game_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$MarginContainer/mainMenu/center/mainButtons.visible = false
	$MarginContainer/mainMenu/center/newGameButtons.visible = true


func _on_load_game_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.changeScene(sceneManager.world)


func _on_options_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$MarginContainer/mainMenu/center/mainButtons.visible = false
	$MarginContainer/mainMenu/center/optionsVolume.visible = true
	$MarginContainer/mainMenu/center/optionsOther.visible = true
	$MarginContainer/mainMenu/lowerButtons.visible = false


func _on_quit_pressed():
	sceneManager.saveGameProgression()
	get_tree().quit()


func _on_yes_overwrite_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.maxLvl = 0
	sceneManager.maxCheckpoint = 0
	sceneManager.changeScene(sceneManager.world)


func _on_no_overwrite_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$MarginContainer/mainMenu/center/mainButtons.visible = true
	$MarginContainer/mainMenu/center/newGameButtons.visible = false


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_environment_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_voice_slider_value_changed(value):
	AudioServer.set_bus_volume_db(3, linear_to_db(value))


func _on_back_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.saveGameSettings()
	$MarginContainer/mainMenu/center/mainButtons.visible = true
	$MarginContainer/mainMenu/center/optionsVolume.visible = false
	$MarginContainer/mainMenu/center/optionsOther.visible = false
	$MarginContainer/mainMenu/lowerButtons.visible = true

func _on_subtitles_toggled(toggled_on):
	gameSettings.subtitles = toggled_on


func _on_screen_type_toggled(toggled_on):
	$"/root/AudioManager/UI/pressButton".play(0)
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_key_bindings_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	var menu = keybindingsMenu.instantiate()
	add_child(menu)


func _on_sensitivity_slider_drag_ended(_value_changed):
	gameSettings.cameraSensitivity = $MarginContainer/mainMenu/center/optionsOther/sensitivitySlider.value


func _on_fov_slider_drag_ended(_value_changed):
	gameSettings.fieldOfView = $MarginContainer/mainMenu/center/optionsOther/fovSlider.value


func _on_credits_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$MarginContainer/mainMenu/center/mainButtons.visible = false
	$MarginContainer/mainMenu/center/newGameButtons.visible = false
	$MarginContainer/mainMenu/center/optionsVolume.visible = false
	$MarginContainer/mainMenu/center/optionsOther.visible = false
	$MarginContainer/mainMenu/center/version.visible = false
	$MarginContainer/mainMenu/lowerButtons/credits.visible = false
	$MarginContainer/mainMenu/lowerButtons/version.visible = false
	$MarginContainer/mainMenu/lowerButtons/backLower.visible = true
	$MarginContainer/mainMenu/center/creditsLeft.visible = true
	$MarginContainer/mainMenu/center/creditsRight.visible = true


func _on_version_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$MarginContainer/mainMenu/center/mainButtons.visible = false
	$MarginContainer/mainMenu/center/newGameButtons.visible = false
	$MarginContainer/mainMenu/center/optionsVolume.visible = false
	$MarginContainer/mainMenu/center/optionsOther.visible = false
	$MarginContainer/mainMenu/center/creditsLeft.visible = false
	$MarginContainer/mainMenu/center/creditsRight.visible = false
	$MarginContainer/mainMenu/lowerButtons/credits.visible = false
	$MarginContainer/mainMenu/lowerButtons/version.visible = false
	$MarginContainer/mainMenu/lowerButtons/backLower.visible = true
	$MarginContainer/mainMenu/center/version.visible = true


func _on_back_lower_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$MarginContainer/mainMenu/center/mainButtons.visible = true
	$MarginContainer/mainMenu/lowerButtons/credits.visible = true
	$MarginContainer/mainMenu/lowerButtons/version.visible = true
	$MarginContainer/mainMenu/lowerButtons/backLower.visible = false
	$MarginContainer/mainMenu/center/creditsLeft.visible = false
	$MarginContainer/mainMenu/center/creditsRight.visible = false
	$MarginContainer/mainMenu/center/version.visible = false
