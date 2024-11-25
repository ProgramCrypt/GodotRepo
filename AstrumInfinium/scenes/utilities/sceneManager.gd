extends Control

@onready var audioManager = get_node("/root/AudioManager")
@onready var gameSettings = get_node("/root/GameSettings")

var saveProgressionPath = "user://AstrumInfiniumProgressionSaveFile.save"
var saveSettingsPath = "user://AstrumInfiniumSettingsSaveFile.save"

@export var mainMenu : PackedScene
@export var world : PackedScene
@export var cutScenes : Array[PackedScene]
@export var lvlScenes : Array[PackedScene]

var maxLvl = 0
var maxCheckpoint = 0


func _ready():
	if FileAccess.file_exists(saveProgressionPath):
		var file = FileAccess.open(saveProgressionPath, FileAccess.READ)
		maxLvl = file.get_var()
		maxCheckpoint = file.get_var()
		file.close()
	if FileAccess.file_exists(saveSettingsPath):
		var file = FileAccess.open(saveSettingsPath, FileAccess.READ)
		AudioServer.set_bus_volume_db(0, linear_to_db(file.get_var()))
		AudioServer.set_bus_volume_db(1, linear_to_db(file.get_var()))
		AudioServer.set_bus_volume_db(2, linear_to_db(file.get_var()))
		AudioServer.set_bus_volume_db(3, linear_to_db(file.get_var()))
		gameSettings.subtitles = file.get_var()
		gameSettings.fullscreen = file.get_var()
		gameSettings.cameraSensitivity = file.get_var()
		gameSettings.fieldOfView = file.get_var()
		file.close()


func changeScene(scene):
	get_tree().change_scene_to_packed(scene)
	'audioManager.musicOff()
	if scene in lvlScenes:
		audioManager.playLvlMusic()'


func restartScene():
	get_tree().reload_current_scene()
	get_tree().paused = false


func quitGame():
	get_tree().quit()


func saveGameProgression():
	var file = FileAccess.open(saveProgressionPath, FileAccess.WRITE)
	file.store_var(maxLvl)
	file.store_var(maxCheckpoint)
	file.close()


func saveGameSettings():
	var file = FileAccess.open(saveSettingsPath, FileAccess.WRITE)
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(0)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(1)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(2)))
	file.store_var(db_to_linear(AudioServer.get_bus_volume_db(3)))
	file.store_var(gameSettings.subtitles)
	file.store_var(gameSettings.fullscreen)
	#add saving for subtitles, fullscreen, and keybindings. Also, add basic keybindings and make conroller work
	file.store_var(gameSettings.cameraSensitivity)
	file.store_var(gameSettings.fieldOfView)
	file.close()
