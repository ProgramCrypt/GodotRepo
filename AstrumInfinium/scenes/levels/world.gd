extends Node3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")
@onready var sceneManager = get_node("/root/SceneManager")

var player


func _ready():
	changeLvl(sceneManager.lvlScenes[sceneManager.maxLvl])
	player = get_tree().get_first_node_in_group('player')
	player.healthChanged.connect(updateVignette)
	resetPlayer()


func updateVignette(health):
	$HUD/vignette.material.set_shader_parameter('multiplier', pow(1.214814, health)/10)
	$HUD/vignette.material.set_shader_parameter('softness', pow(1.214814, health)/10 + 0.3)


func changeLvl(level):
	for lvl in get_tree().get_nodes_in_group('level'):
		lvl.queue_free()
	var instantiatedLevel = level.instantiate()
	get_tree().root.get_node('world').call_deferred('add_child', instantiatedLevel)
	get_tree().root.get_node('world').call_deferred('resetPlayer')


func resetPlayer(playerPosition = Vector3(0, 10, -12)):
	$Player.transform = Transform3D(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, -1), playerPosition)
	physicsHandler.globalGravityDir = Vector3(0, -1, 0)
	$Player.knownGravity = physicsHandler.globalGravityDir
	$Player.up_direction = -1 * physicsHandler.globalGravityDir
	$Player.changeHealth(20)
