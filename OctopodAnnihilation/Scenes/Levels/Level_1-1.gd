extends Node2D

@export var spawnRoom: PackedScene
@export var vatRoom: PackedScene
@export var derelictVatRoom: PackedScene
@export var octoVatRoom: PackedScene
@export var derelictOctoVatRoom: PackedScene
@export var serverRoom: PackedScene
@export var serverRoom1: PackedScene

@export var totalRooms: int = 10
var walker = Vector2i(0,0)
var hasRoom = [walker]
var gridLen = 15 * 100 #15 tiles by 100 pixels
var cardinals = [0, 1, 2, 3]

func _ready():
	var r = spawnRoom.instantiate()
	add_child(r)
	r.position = walker
	
	var roomArray = [vatRoom, derelictVatRoom, octoVatRoom, derelictOctoVatRoom, serverRoom, serverRoom1]
	
	while totalRooms > 0:
		var dir = cardinals[randi() % cardinals.size()]
		if dir == 0: #Up
			walker.y -= gridLen
			print('up')
		if dir == 1: #Down
			walker.y += gridLen
			print('down')
		if dir == 2: #Right
			walker.x += gridLen
			print('right')
		if dir == 3: #Left
			walker.x -= gridLen
			print('left')
		
		if walker not in hasRoom:
			var room = roomArray[randi() % roomArray.size()]
			room = roomArray[0]
			r = room.instantiate()
			add_child(r)
			r.position = walker
			hasRoom.append(walker)
			totalRooms -= 1
	
	get_tree().get_nodes_in_group('player')[0].position = Vector2i((gridLen/2),(gridLen/2)+100)
	get_tree().get_nodes_in_group('projectileEnemies')[0].position = Vector2i((gridLen/2),(gridLen/2))