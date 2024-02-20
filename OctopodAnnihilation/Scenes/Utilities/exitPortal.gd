extends Area2D

@onready var sceneManager = get_node("/root/SceneManager")

func _on_body_entered(body):
	if body.is_in_group("player"):
		sceneManager.modifyDifficulty(1)
		print(sceneManager.difficulty)
		sceneManager.restartScene()
