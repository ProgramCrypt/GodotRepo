extends Area2D

@onready var sceneManager = get_node("/root/SceneManager")

@export var upgradeGUI : PackedScene

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().paused = true
		sceneManager.modifyDifficulty(1)
		print("difficulty = ", sceneManager.difficulty)
		var GUI = upgradeGUI.instantiate()
		get_tree().root.get_node("Game").get_node("HUD").call_deferred("add_child", GUI)
