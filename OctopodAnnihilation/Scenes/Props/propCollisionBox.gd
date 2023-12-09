extends Area2D

var health = 0
var damagedAtlas = Vector2i()
var damagedType = ""
var cellLoc = Vector2i()

func defineType(type, cell):
	cellLoc = cell
	
	if type == "table":
		health = 3
		damagedAtlas = Vector2i(7, 2)
	if type == "server":
		health = 3
		damagedAtlas = Vector2i(1, 2)
		damagedType = "damagedServer"
	if type == "damagedServer":
		health = 3
		damagedAtlas = Vector2i(2, 2)
	if type == "orangeVat":
		health = 3
		damagedAtlas = Vector2i(3, 4)
	if type == "blueVat":
		health = 3
		damagedAtlas = Vector2i(4, 4)
	if type == "emptyVat":
		health = 3
		damagedAtlas = Vector2i(5, 4)
	if type == "table2":
		health = 3
		damagedAtlas = Vector2i(7, 3)
	if type == "server2":
		health = 3
		damagedAtlas = Vector2i(1, 3)
		damagedType = "damagedServer2"
	if type == "damagedServer2":
		health = 3
		damagedAtlas = Vector2i(2, 3)
	if type == "orangeVat2":
		health = 3
		damagedAtlas = Vector2i(3, 5)
	if type == "blueVat2":
		health = 3
		damagedAtlas = Vector2i(4, 5)
	if type == "emptyVat2":
		health = 3
		damagedAtlas = Vector2i(5, 5)

func _on_area_entered(area):
	print('trigg')
	if area.is_in_group("projectile"):
		health -= 1
		print('hit')

func _physics_process(_delta):
	if health == 0:
		get_parent().changeTile(cellLoc, damagedAtlas)
		if damagedType != "":
			defineType(damagedType, cellLoc)
