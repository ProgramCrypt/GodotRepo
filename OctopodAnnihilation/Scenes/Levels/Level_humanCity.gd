extends Node2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var sceneManager = get_node("/root/SceneManager")

@export var exitPortal: PackedScene

@export var totalRooms: int = 10
var walker = Vector2i(0,0)
var hasRoom = [walker]
var gridLen = 15 * 100 #15 tiles by 100 pixels
var cardinals = [0, 1, 2, 3]

@export var spawnRoom: PackedScene
@export var businessDistrict1: PackedScene
@export var businessDistrict2: PackedScene
@export var drainageRoom1: PackedScene
@export var drainageRoom2: PackedScene
@export var amphibianBossRoom: PackedScene

var playerStartingPos = Vector2((gridLen/2),(gridLen/2)+100)

func _ready():
	playerStats.healthChanged.connect(setHealth)
	playerStats.healthChanged.connect(setMaxHealth)
	playerStats.energyChanged.connect(setEnergy)
	playerStats.energyChanged.connect(setMaxEnergy)
	playerStats.scrapChanged.connect(setScrap)
	$player.activeAbilityCooldown.connect(setActiveCooldown)
	$player.setActiveActive.connect(setActiveActive)
	
	setHealth()
	setMaxHealth()
	setEnergy()
	setMaxEnergy()
	setScrap()
	setMaxActiveCooldown()
	setActiveCooldown()
	setActiveActive()
	
	#miniMap setup
	$HUD/Control.clip_contents = true
	$HUD/Control/miniMap.setRoom(Vector2i(0, 0), "spawn")
	
	#Map generation
	var r = spawnRoom.instantiate()
	add_child(r)
	r.position = walker
	
	var roomArray = [businessDistrict1, businessDistrict2, drainageRoom1, drainageRoom2]
	var normalRooms = [businessDistrict1, businessDistrict2, drainageRoom1, drainageRoom2]
	var derelictRooms = []
	var instantiatedRooms = [r]
	var dir = []
	var dirWeight = 0
	
	while totalRooms > 0:
		dir.append(cardinals[randi() % cardinals.size()])
		'if dir.size() > 1:
			if dir[0] == dir[1]:
				dirWeight += 1
			else:
				dirWeight = 0
		if dirWeight >= 2:
			dir.append(dir[-1])
		dir = [dir[randi() % dir.size()]]' #makes world generation more stringy
		if dir[-1] == 0: #Up
			walker.y -= gridLen
		if dir[-1] == 1: #Down
			walker.y += gridLen
		if dir[-1] == 2: #Right
			walker.x += gridLen
		if dir[-1] == 3: #Left
			walker.x -= gridLen
		
		if walker not in hasRoom:
			var room
			if totalRooms == 1 and sceneManager.bossLevel == true:
				room = amphibianBossRoom
			else:
				room = roomArray[randi() % roomArray.size()]
			r = room.instantiate()
			add_child(r)
			r.position = walker
			hasRoom.append(walker)
			instantiatedRooms.append(r)
			totalRooms -= 1
			
			#miniMap
			var cell = Vector2i(walker.x/gridLen, walker.y/gridLen)
			if room in normalRooms:
				$HUD/Control/miniMap.setRoom(cell, "normal")
			if room in derelictRooms:
				$HUD/Control/miniMap.setRoom(cell, "derelict")
	
	#fill unconnected passageways
	var fill = []
	for room in hasRoom:
		var directions = []
		if Vector2i(room.x, room.y-gridLen) not in hasRoom:
			directions.append("up")
		if Vector2i(room.x, room.y+gridLen) not in hasRoom:
			directions.append("down")
		if Vector2i(room.x+gridLen, room.y) not in hasRoom:
			directions.append("right")
		if Vector2i(room.x-gridLen, room.y) not in hasRoom:
			directions.append("left")
		fill.append([room, directions])
	
	#create level exit
	var exitRoom = fill[-1]
	var exitRoomIndex = fill.find(exitRoom)
	var exitDirection = exitRoom[1][randi() % exitRoom[1].size()]
	var directionIndex = exitRoom[1].find(exitDirection)
	fill[exitRoomIndex][1].pop_at(directionIndex)
	var exit = exitPortal.instantiate()
	add_child(exit)
	var exitOffset 
	if exitDirection == "up":
		exitOffset = Vector2i(0, -(gridLen/2))
	if exitDirection == "down":
		exitOffset = Vector2i(0, (gridLen/2))
	if exitDirection == "right":
		exitOffset = Vector2i((gridLen/2), 0)
	if exitDirection == "left":
		exitOffset = Vector2i(-(gridLen/2), 0)
	exit.position = fill[exitRoomIndex][0] + exitOffset + Vector2i((gridLen/2),(gridLen/2))
	
	for room in fill:
		var index = hasRoom.find(room[0],0)
		instantiatedRooms[index].fillPassageways(room[1])
	
	if sceneManager.bossLevel == false:
		$HUD/Control/miniMap.setRoom(Vector2i(exitRoom[0].x/gridLen, exitRoom[0].y/gridLen), "exit")
	elif sceneManager.bossLevel == true:
		$HUD/Control/miniMap.setRoom(Vector2i(exitRoom[0].x/gridLen, exitRoom[0].y/gridLen), "boss")
	
	#Set player location
	get_tree().get_nodes_in_group('player')[0].position = playerStartingPos
	#get_tree().get_nodes_in_group('projectileEnemies')[0].position = Vector2i((gridLen/2),(gridLen/2))


func _process(delta):
	$HUD/Control/miniMap.position = ((-$player.position - playerStartingPos)/60) + Vector2(112.5, 115) #60 is ratio of map to miniMap size (1500/25). Vector2(112.5, 115) is miniMap position offset within Control node


func setHealth() -> void:
	$HUD/healthLabel.text = "Health: " + str(int(ceil(playerStats.currentHealth))) + "/" + str(playerStats.maxHealth)
	#$HUD/healthLabel.text = "Health: " + str((ceil(playerStats.currentHealth * 10) / 10)) + "/" + str(playerStats.maxHealth) #health value displays as float with 1 decimal place
	$HUD/healthBar.value = playerStats.currentHealth

func setMaxHealth() -> void:
	$HUD/healthBar.max_value = playerStats.maxHealth

func setEnergy() -> void:
	$HUD/energyLabel.text = "Energy: " + str(int(ceil(playerStats.currentEnergy))) + "/" + str(playerStats.maxEnergy)
	$HUD/energyBar.value = playerStats.currentEnergy

func setMaxEnergy() -> void:
	$HUD/energyBar.max_value = playerStats.maxEnergy

func setScrap() -> void:
	$HUD/scrapLabel.text = str(playerStats.currentScrap)

func setMaxActiveCooldown() -> void:
	$HUD/activeCooldownBar.max_value = playerStats.playerTypeDict[playerStats.playerType].activeAbilityCooldown

func setActiveCooldown() -> void:
	$HUD/activeCooldownBar.value = $player/activeAbilityCooldownTimer.time_left

func setActiveActive() -> void:
	$HUD/activeCooldownPanel.visible = $player.isActiveActive
 
