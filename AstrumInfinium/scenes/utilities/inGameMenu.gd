extends CanvasLayer

@onready var physicsHandler = get_node("/root/PhysicsHandler")
@onready var sceneManager = get_node("/root/SceneManager")
@onready var gameSettings = get_node("/root/GameSettings")

@export var keybindingsMenu : PackedScene

@export var Lvl1 : PackedScene
@export var Lvl2 : PackedScene
@export var Lvl3 : PackedScene
@export var Lvl4 : PackedScene


func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control/MarginContainer/pauseMenu.visible = true
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = false
	$Timer.one_shot = true
	$Timer.start(0.3)
	$"/root/AudioManager/UI/pressButton".play(0)
	
	$Control/MarginContainer/optionsMenu/VBoxContainer/HBoxContainer/volume/masterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Control/MarginContainer/optionsMenu/VBoxContainer/HBoxContainer/volume/musicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$Control/MarginContainer/optionsMenu/VBoxContainer/HBoxContainer/volume/sfxSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	$Control/MarginContainer/optionsMenu/VBoxContainer/HBoxContainer/volume/voiceSlider.value = db_to_linear(AudioServer.get_bus_volume_db(3))


func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if $Timer.time_left <= 0:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			queue_free()


func _on_resume_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_levels_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$Control/MarginContainer/pauseMenu.visible = false
	$Control/MarginContainer/levelMenu.visible = true
	$Control/MarginContainer/optionsMenu.visible = false


func _on_options_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$Control/MarginContainer/pauseMenu.visible = false
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = true


func _on_exit_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.saveGameProgression()
	sceneManager.changeScene(sceneManager.mainMenu)
	get_tree().paused = false
	queue_free()


func levelReset(selectedLevel):
	$"/root/AudioManager/UI/pressButton".play(0)
	for lvl in get_tree().get_nodes_in_group('level'):
		lvl.queue_free()
	var level = selectedLevel.instantiate()
	get_tree().root.get_node('world').call_deferred('add_child', level)
	get_tree().root.get_node('world').call_deferred('resetPlayer')
	
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_1_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	levelReset(Lvl1)


func _on_2_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	levelReset(Lvl2)


func _on_3_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	levelReset(Lvl3)


func _on_4_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	levelReset(Lvl4)


func _on_5_pressed():
	pass # Replace with function body.


func _on_6_pressed():
	pass # Replace with function body.


func _on_7_pressed():
	pass # Replace with function body.


func _on_8_pressed():
	pass # Replace with function body.


func _on_9_pressed():
	pass # Replace with function body.


func _on_10_pressed():
	pass # Replace with function body.


func _on_11_pressed():
	pass # Replace with function body.


func _on_12_pressed():
	pass # Replace with function body.


func _on_13_pressed():
	pass # Replace with function body.


func _on_14_pressed():
	pass # Replace with function body.


func _on_15_pressed():
	pass # Replace with function body.


func _on_16_pressed():
	pass # Replace with function body.


func _on_17_pressed():
	pass # Replace with function body.


func _on_18_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	$Control/MarginContainer/pauseMenu.visible = true
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = false


func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_voice_value_changed(value):
	AudioServer.set_bus_volume_db(3, linear_to_db(value))


func _on_subtitles_toggled(toggled_on):
	gameSettings.subtitles = toggled_on


func _on_fullscreen_toggled(toggled_on):
	$"/root/AudioManager/UI/pressButton".play(0)
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_keybindings_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	var menu = keybindingsMenu.instantiate()
	add_child(menu)


func _on_sensitivity_slider_drag_ended(_value_changed):
	gameSettings.cameraSensitivity = $MarginContainer/mainMenu/center/optionsOther/sensitivitySlider.value


func _on_fov_slider_drag_ended(_value_changed):
	gameSettings.fieldOfView = $MarginContainer/mainMenu/center/optionsOther/fovSlider.value


func _on_back1_pressed():
	$"/root/AudioManager/UI/pressButton".play(0)
	sceneManager.saveGameSettings()
	$Control/MarginContainer/pauseMenu.visible = true
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = false
