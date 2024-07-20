extends Control

@onready var sceneManager = get_node("/root/SceneManager")

var savePath = "user://OctopodAnnihilationSettingsSaveFile.save"

@export var bus_name: String
var bus_index: int


func _ready() -> void:
	'bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_master_volume_slider_drag_ended)
	
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))'
	
	$MarginContainer/VBoxContainer/masterVolume/masterVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$MarginContainer/VBoxContainer/musicVolume/musicVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$MarginContainer/VBoxContainer/SFXVolume/SFXVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_back_pressed():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(0)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(1)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(2)))
	file.close()
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("mainMenu")


func _on_master_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
