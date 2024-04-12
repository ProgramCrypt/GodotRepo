extends CanvasLayer

@onready var sceneManager = get_node("/root/SceneManager")
@onready var playerStats = get_node("/root/ActivePlayerStats")


func _ready():
	get_tree().paused = true
	$Timer.one_shot = true
	$Timer.start(0.5)
	$MarginContainer/MarginContainer/VBoxContainer/score.text = "Score: " + str(playerStats.playerScore)
	
	var score = [playerStats.playerScore, playerStats.playerType]
	var scoreList = sceneManager.loadScoreData()
	scoreList.append(score)
	scoreList.sort_custom(sortAscending)
	print(scoreList)
	scoreList.pop_back()
	sceneManager.saveScores(scoreList)


func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if $Timer.time_left <= 0:
			playerStats.playerScore = 0
			playerStats.currentHealth = 1
			sceneManager.difficulty = 4
			deleteSave()
			get_tree().paused = false
			sceneManager.switchScene("mainMenu")
			queue_free()


func deleteSave():
	DirAccess.remove_absolute("user://OctopodAnnihilationSaveFile.save")


func sortAscending(a, b):
	if a[0] < b[0]:
		return false
	return true


func _on_retry_pressed():
	if playerStats.playerType == "superSoldier":
		playerStats.initialize(playerStats.superSoldier)
	if playerStats.playerType == "sniper":
		playerStats.initialize(playerStats.sniper)
	if playerStats.playerType == "tanker":
		playerStats.initialize(playerStats.tanker)
	if playerStats.playerType == "infiltrator":
		playerStats.initialize(playerStats.infiltrator)
	if playerStats.playerType == "cyborg":
		playerStats.initialize(playerStats.cyborg)
	if playerStats.playerType == "mutant":
		playerStats.initialize(playerStats.mutant)
	if playerStats.playerType == "robot":
		playerStats.initialize(playerStats.robot)
	#playerStats.saveWeapon(playerStats.plasma, playerStats.weapon1)
	#playerStats.saveWeapon(playerStats.shield, playerStats.weapon2)
	
	deleteSave()
	get_tree().paused = false
	sceneManager.switchScene("level1_1")
	queue_free()


func _on_exit_pressed():
	playerStats.playerScore = 0
	playerStats.currentHealth = 1
	sceneManager.difficulty = 4
	deleteSave()
	get_tree().paused = false
	sceneManager.switchScene("mainMenu")
	queue_free()
