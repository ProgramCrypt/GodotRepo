extends Area3D

@onready var sceneManager = get_node("/root/SceneManager")

var teleport = false
var timer = 0


func nextLevel():
	var index = sceneManager.lvlScenes.find(sceneManager.currentLvl)
	sceneManager.maxLvl = index + 1
	get_tree().root.get_node('world').changeLvl(sceneManager.lvlScenes[index + 1])


func _on_body_entered(body):
	if body.is_in_group('player') and $Timer.is_stopped():
		teleport = true


func _process(delta):
	if teleport == true:
		timer += delta
		get_node("/root/world/HUD/portalOverlay").color = Color(0, 1, 0, timer)
		if timer >= 1:
			teleport = false
			timer = 0
			get_node("/root/world/HUD/portalOverlay").color = Color(0, 1, 0, 0)
			nextLevel()
