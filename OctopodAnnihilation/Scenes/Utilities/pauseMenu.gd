extends CanvasLayer

@onready var sceneManager = get_node("/root/SceneManager")


func _ready():
	get_tree().paused = true
	$Timer.one_shot = true
	$Timer.start(0.5)

func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if $Timer.time_left <= 0:
			get_tree().paused = false
			queue_free()


func _on_resume_pressed():
	get_tree().paused = false
	queue_free()


func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	sceneManager.saveGame()
	get_tree().paused = false
	sceneManager.switchScene("mainMenu")
	queue_free()
