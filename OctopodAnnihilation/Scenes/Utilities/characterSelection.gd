extends Control

@onready var sceneManager = get_node("/root/SceneManager")
@onready var playerStats = get_node("/root/ActivePlayerStats")


func _ready():
	playerStats.playerScore = 0
	playerStats.activeWeapon = "weapon1"


func _on_back_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	sceneManager.switchScene("mainMenu")


func _on_super_soldier_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.superSoldier)
	playerStats.playerType = "superSoldier"
	playerStats.saveWeapon(playerStats.ballistic, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.hammer, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")


func _on_sniper_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.sniper)
	playerStats.playerType = "sniper"
	playerStats.saveWeapon(playerStats.ballistic, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.laser, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")


func _on_tanker_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.tanker)
	playerStats.playerType = "tanker"
	playerStats.saveWeapon(playerStats.plasma, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.hammer, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")


func _on_infiltrator_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.infiltrator)
	playerStats.playerType = "infiltrator"
	playerStats.saveWeapon(playerStats.plasma, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.shield, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")


func _on_cyborg_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.cyborg)
	playerStats.playerType = "cyborg"
	playerStats.saveWeapon(playerStats.plasma, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.laser, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")


func _on_mutant_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.mutant)
	playerStats.playerType = "mutant"
	playerStats.saveWeapon(playerStats.ballistic, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.shield, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")


func _on_robot_pressed():
	$"/root/AudioManager/UI/selectButton".play(0)
	playerStats.initialize(playerStats.robot)
	playerStats.playerType = "robot"
	playerStats.saveWeapon(playerStats.laser, playerStats.weapon1)
	playerStats.saveWeapon(playerStats.shield, playerStats.weapon2)
	sceneManager.completedLevels = []
	sceneManager.bossLevel = false
	sceneManager.switchScene("level1_1")
