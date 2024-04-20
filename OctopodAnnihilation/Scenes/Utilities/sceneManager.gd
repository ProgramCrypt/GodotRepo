extends Node2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var audioManager = get_node("/root/AudioManager")

var savePath = "user://OctopodAnnihilationSaveFile.save"
var scoreSavePath = "user://OctopodAnnihilationScoreSaveFile.save"

@export var mainMenu : PackedScene
@export var options : PackedScene
@export var versionChangelog : PackedScene
@export var characterSelection : PackedScene
@export var scoreboard : PackedScene
@export var level1_1 : PackedScene
var scenes = {}

var difficulty: int = 4
var level = "level1_1"


func _ready():
	scenes = {"mainMenu": mainMenu, "options": options, "versionChangelog": versionChangelog, "characterSelection": characterSelection, "scoreboard": scoreboard, "level1_1": level1_1}
	#switchScene("mainMenu")
	
	var scores = loadScoreData()
	if scores == null:
		saveScores([])
	else:
		saveScores(scores)


func addScene(sceneAlias : String, scenePath : String) -> void:
	scenes[sceneAlias] = scenePath


func removeScene(sceneAlias : String) -> void:
	scenes.erase(sceneAlias)


func switchScene(sceneAlias : String) -> void:
	#print("loading: " + str(scenes[sceneAlias]))
	get_tree().change_scene_to_packed(scenes[sceneAlias])
	audioManager.musicOff()
	if sceneAlias == "level1_1":
		$"/root/AudioManager/OST/labsTheme".play(0)


func restartScene() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false


func quitGame() -> void:
	get_tree().quit()


func modifyDifficulty(modifier):
	difficulty += modifier


func saveGame():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(difficulty)
	file.store_var(level)
	file.store_var(playerStats.playerType)
	file.store_var(playerStats.weapon1)
	file.store_var(playerStats.weapon2)
	file.store_var(playerStats.appliedWeapon1Upgrades)
	file.store_var(playerStats.appliedWeapon2Upgrades)
	file.store_var(playerStats.maxHealth)
	file.store_var(playerStats.currentHealth)
	file.store_var(playerStats.maxEnergy)
	file.store_var(playerStats.currentEnergy)
	file.store_var(playerStats.speed)
	file.store_var(playerStats.strength)
	file.store_var(playerStats.rateOfFire)
	file.store_var(playerStats.gunAccuracy)
	file.store_var(playerStats.ballisticResistance)
	file.store_var(playerStats.laserResistance)
	file.store_var(playerStats.plasmaResistance)
	file.store_var(playerStats.bleedingResistance)
	file.store_var(playerStats.fireResistance)
	file.store_var(playerStats.explosionResistance)
	file.store_var(playerStats.slowResistance)
	file.store_var(playerStats.stunResistance)
	file.store_var(playerStats.currentScrap)
	file.store_var(playerStats.appliedArmorUpgrades)
	file.close()


func loadGameData():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		difficulty = file.get_var()
		level = file.get_var()
		playerStats.playerType = file.get_var()
		playerStats.weapon1 = file.get_var()
		playerStats.weapon2 = file.get_var()
		playerStats.appliedWeapon1Upgrades = file.get_var()
		playerStats.appliedWeapon2Upgrades = file.get_var()
		playerStats.maxHealth = file.get_var()
		playerStats.currentHealth = file.get_var()
		playerStats.maxEnergy = file.get_var()
		playerStats.currentEnergy = file.get_var()
		playerStats.speed = file.get_var()
		playerStats.strength = file.get_var()
		playerStats.rateOfFire = file.get_var()
		playerStats.gunAccuracy = file.get_var()
		playerStats.ballisticResistance = file.get_var()
		playerStats.laserResistance = file.get_var()
		playerStats.plasmaResistance = file.get_var()
		playerStats.bleedingResistance = file.get_var()
		playerStats.fireResistance = file.get_var()
		playerStats.explosionResistance = file.get_var()
		playerStats.slowResistance = file.get_var()
		playerStats.stunResistance = file.get_var()
		playerStats.currentScrap = file.get_var()
		playerStats.appliedArmorUpgrades = file.get_var()
		file.close()


func saveScores(scores):
	var file = FileAccess.open(scoreSavePath, FileAccess.WRITE)
	if scores.size() < 10:
		for i in range(10-scores.size()):
			scores.append([0, "N/A"])
	for score in scores:
		file.store_var(score[0])
		file.store_var(score[1])
	file.close()


func loadScoreData():
	if FileAccess.file_exists(scoreSavePath):
		var file = FileAccess.open(scoreSavePath, FileAccess.READ)
		var scores = []
		for i in range(10):
			var score = []
			score.append(file.get_var())
			score.append(file.get_var())
			scores.append(score)
		return scores
		file.close()
	else:
		return null
