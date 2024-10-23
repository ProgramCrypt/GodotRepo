extends CanvasLayer

@onready var physicsHandler = get_node("/root/PhysicsHandler")

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
	
	$Control/MarginContainer/optionsMenu/VBoxContainer/volume/sliders/master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Control/MarginContainer/optionsMenu/VBoxContainer/volume/sliders/music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$Control/MarginContainer/optionsMenu/VBoxContainer/volume/sliders/sfx.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if $Timer.time_left <= 0:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			queue_free()


func _on_resume_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_levels_pressed():
	$Control/MarginContainer/pauseMenu.visible = false
	$Control/MarginContainer/levelMenu.visible = true
	$Control/MarginContainer/optionsMenu.visible = false


func _on_options_pressed():
	$Control/MarginContainer/pauseMenu.visible = false
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = true


func _on_exit_pressed():
	get_tree().quit()


func levelReset(selectedLevel):
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
	levelReset(Lvl1)


func _on_2_pressed():
	levelReset(Lvl2)


func _on_3_pressed():
	levelReset(Lvl3)


func _on_4_pressed():
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
	$Control/MarginContainer/pauseMenu.visible = true
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = false


func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_back1_pressed():
	$Control/MarginContainer/pauseMenu.visible = true
	$Control/MarginContainer/levelMenu.visible = false
	$Control/MarginContainer/optionsMenu.visible = false
