extends Control

var savePath = "user://OctopodAnnihilationSettingsSaveFile.save"


func _ready():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		AudioServer.set_bus_volume_db(0, linear_to_db(file.get_var()))
		AudioServer.set_bus_volume_db(1, linear_to_db(file.get_var()))
		AudioServer.set_bus_volume_db(2, linear_to_db(file.get_var()))
		file.close()


func ballisticFire():
	var audioFiles = $weapons/ballistic.get_children()
	var audio = audioFiles[randi() % audioFiles.size()]
	audio.play(0)

func plasmaFire():
	var audioFiles = $weapons/plasma.get_children()
	var audio = audioFiles[randi() % audioFiles.size()]
	audio.play(0)

func hammerSwing():
	var audioFiles = $weapons/hammer/swing.get_children()
	var audio = audioFiles[randi() % audioFiles.size()]
	audio.play(0)

func shieldSwing():
	var audioFiles = $weapons/shield.get_children()
	var audio = audioFiles[randi() % audioFiles.size()]
	audio.play(0)


func musicOff():
	for music in $OST.get_children():
		if music.playing == true:
			music.stop()


func _on_labs_theme_finished():
	$OST/labsTheme.play(0)
