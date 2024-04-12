extends Control

@onready var sceneManager = get_node("/root/SceneManager")


func _ready():
	var scores = sceneManager.loadScoreData()
	scores.sort_custom(sortAscending)
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score1.text = str(scores[0][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score2.text = str(scores[1][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score3.text = str(scores[2][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score4.text = str(scores[3][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score5.text = str(scores[4][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score6.text = str(scores[5][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score7.text = str(scores[6][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score8.text = str(scores[7][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score9.text = str(scores[8][0])
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/scores/score10.text = str(scores[9][0])
	
	var playerTypeList = []
	for score in scores:
		var playerType
		if str(score[1]) == 'superSoldier':
			playerType = "Super Soldier"
		elif str(score[1]) == 'sniper':
			playerType = "Sniper"
		elif str(score[1]) == 'tanker':
			playerType = "Tanker"
		elif str(score[1]) == 'infiltrator':
			playerType = "Infiltrator"
		elif str(score[1]) == 'cyborg':
			playerType = "Cyborg"
		elif str(score[1]) == 'mutant':
			playerType = "Mutant"
		elif str(score[1]) == 'robot':
			playerType = "Robot"
		else:
			playerType = "N/A"
		playerTypeList.append(playerType)
	
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character1.text = playerTypeList[0]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character2.text = playerTypeList[1]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character3.text = playerTypeList[2]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character4.text = playerTypeList[3]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character5.text = playerTypeList[4]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character6.text = playerTypeList[5]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character7.text = playerTypeList[6]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character8.text = playerTypeList[7]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character9.text = playerTypeList[8]
	$MarginContainer/VBoxContainer/MarginContainer/scoreboardBox/characters/character10.text = playerTypeList[9]


func _on_exit_pressed():
	sceneManager.switchScene("mainMenu")


func sortAscending(a, b):
	'if typeof(a[0]) == 2 and typeof(b[0]) == 2:
		if a[0] < b[0]:
			return true
		return false
	else:
		if typeof(a[0]) == 2:
			'
	
	if a[0] < b[0]:
		return false
	return true
