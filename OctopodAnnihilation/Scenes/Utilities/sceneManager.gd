extends Node2D


@export var scenes: Dictionary = {}
@export var currentScene: String = ""

var difficulty: int = 1


func addScene(sceneAlias : String, scenePath : String) -> void:
	scenes[sceneAlias] = scenePath


func removeScene(sceneAlias : String) -> void:
	scenes.erase(sceneAlias)


func switchScene(sceneAlias : String) -> void:
	get_tree().change_scene_to_file(scenes[sceneAlias])


func restartScene() -> void:
	get_tree().reload_current_scene()


func quitGame() -> void:
	get_tree().quit()


func modifyDifficulty(modifier):
	difficulty += modifier
