extends CanvasLayer

@onready var sceneManager = get_node("/root/SceneManager")

var savePath = "user://OctopodAnnihilationSettingsSaveFile.save"

func _ready():
	get_tree().paused = true
	$MarginContainer/MarginContainer/VBoxContainer/mainMenu.visible = true
	$MarginContainer/MarginContainer/VBoxContainer/optionsMenu.visible = false
	$Timer.one_shot = true
	$Timer.start(0.3)

func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if $Timer.time_left <= 0:
			get_tree().paused = false
			queue_free()


func _on_resume_pressed():
	get_tree().paused = false
	$"/root/AudioManager/UI/selectButton".play(0)
	queue_free()


func _on_options_pressed():
	$MarginContainer/MarginContainer/VBoxContainer/optionsMenu/VBoxContainer/masterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$MarginContainer/MarginContainer/VBoxContainer/optionsMenu/VBoxContainer/musicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$MarginContainer/MarginContainer/VBoxContainer/optionsMenu/VBoxContainer/SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	$MarginContainer/MarginContainer/VBoxContainer/mainMenu.visible = false
	$MarginContainer/MarginContainer/VBoxContainer/optionsMenu.visible = true
	$"/root/AudioManager/UI/selectButton".play(0)


func _on_exit_pressed():
	sceneManager.saveGame()
	get_tree().paused = false
	sceneManager.switchScene("mainMenu")
	$"/root/AudioManager/UI/selectButton".play(0)
	queue_free()


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_back_pressed():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(0)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(1)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(2)))
	file.close()
	$MarginContainer/MarginContainer/VBoxContainer/mainMenu.visible = true
	$MarginContainer/MarginContainer/VBoxContainer/optionsMenu.visible = false
	$"/root/AudioManager/UI/selectButton".play(0)
