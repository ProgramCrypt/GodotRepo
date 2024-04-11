extends TileMap

@onready var sceneManager = get_node("/root/SceneManager")

@export var propCollisionBox: PackedScene
@export var chimeraLabGrunt: PackedScene
@export var octopodScientist: PackedScene
@export var octopodEngineer: PackedScene

var tables = []
var servers = []
var vats = []

func _ready():
	for cell in get_used_cells(1):
		var propType = get_cell_atlas_coords(1, cell)
		
		#tables
		if propType in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0), Vector2i(6, 0), Vector2i(7, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1), Vector2i(5, 1), Vector2i(6, 1), Vector2i(7, 1)]:
			var tableBox = propCollisionBox.instantiate()
			add_child(tableBox)
			tableBox.position = map_to_local(cell) - Vector2(0, 10)
			tableBox.get_node("CollisionShape2D").shape.extents = Vector2(27, 27)
			if propType in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0), Vector2i(6, 0), Vector2i(7, 0)]:
				tableBox.defineType("table", cell)
			if propType in [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1), Vector2i(5, 1), Vector2i(6, 1), Vector2i(7, 1)]:
				tableBox.defineType("table2", cell)
			
		#servers
		if propType in [Vector2i(0, 2), Vector2i(1, 2), Vector2i(0, 3), Vector2i(1, 3)]:
			var serverBox = propCollisionBox.instantiate()
			add_child(serverBox)
			serverBox.position = map_to_local(cell) - Vector2(0, 7)
			serverBox.get_node("CollisionShape2D").shape.extents = Vector2(30, 41)
			if propType == Vector2i(0, 2):
				serverBox.defineType("server", cell)
			if propType == Vector2i(0, 3):
				serverBox.defineType("server2", cell)
			if propType == Vector2i(1, 2):
				serverBox.defineType("damagedServer", cell)
			if propType == Vector2i(1, 3):
				serverBox.defineType("damagedServer2", cell)
			
		#vats
		if propType in [Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4), Vector2i(0, 5), Vector2i(1, 5), Vector2i(2, 5)]:
			var vatBox = propCollisionBox.instantiate()
			add_child(vatBox)
			vatBox.position = map_to_local(cell) - Vector2(0, 5)
			vatBox.get_node("CollisionShape2D").shape.extents = Vector2(21, 41)
			if propType == Vector2i(0, 4):
				vatBox.defineType("orangeVat", cell)
			if propType == Vector2i(1, 4):
				vatBox.defineType("blueVat", cell)
			if propType == Vector2i(2, 4):
				vatBox.defineType("emptyVat", cell)
			if propType == Vector2i(0, 5):
				vatBox.defineType("orangeVat2", cell)
			if propType == Vector2i(1, 5):
				vatBox.defineType("blueVat2", cell)
			if propType == Vector2i(2, 5):
				vatBox.defineType("emptyVat2", cell)
	
	#Enemy Spawning
	var roomDifficulty = randi_range(sceneManager.difficulty-1, sceneManager.difficulty+1)
	var spawnerCells = []
	for cell in get_used_cells(3):
		spawnerCells.append(cell)
	
	var enemyArray = []
	while roomDifficulty > 0:
		if len(spawnerCells) > 0:
			var cell = spawnerCells[randi() % spawnerCells.size()]
			spawnerCells.pop_at(spawnerCells.find(cell))
			var spawnerType = get_cell_atlas_coords(3, cell)
			if spawnerType == Vector2i(0, 0):
				var enemy = chimeraLabGrunt.instantiate()
				add_child(enemy)
				enemy.position = map_to_local(cell)
				enemyArray.append(enemy)
				roomDifficulty -= 1
			if spawnerType == Vector2i(1, 0):
				var enemy = octopodScientist.instantiate()
				add_child(enemy)
				enemy.position = map_to_local(cell)
				enemyArray.append(enemy)
				roomDifficulty -= 1
			if spawnerType == Vector2i(2, 0):
				var enemy = octopodEngineer.instantiate()
				add_child(enemy)
				enemy.position = map_to_local(cell)
				enemyArray.append(enemy)
				roomDifficulty -= 1
			if spawnerType == Vector2i(3, 0):
				var enemy
				if randf() >= 0.5:
					enemy = chimeraLabGrunt.instantiate()
				else:
					enemy = octopodScientist.instantiate()
				add_child(enemy)
				enemy.position = map_to_local(cell)
				enemyArray.append(enemy)
				roomDifficulty -= 1
			if spawnerType == Vector2i(4, 0):
				var enemy
				if randf() >= 0.5:
					enemy = octopodScientist.instantiate()
				else:
					enemy = octopodEngineer.instantiate()
				add_child(enemy)
				enemy.position = map_to_local(cell)
				enemyArray.append(enemy)
				roomDifficulty -= 1
		else:
			for enemy in enemyArray:
				enemy.maxHealth += roomDifficulty
				enemy.currentHealth += roomDifficulty
			roomDifficulty = 0


func changeTile(cell, newTile):
	set_cell(1, cell, 1, newTile)


func fillPassageways(directions):
	for cell in get_used_cells(4):
		var tile = get_cell_atlas_coords(4, cell)
		
		if "up" in directions:
			if tile in [Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0), Vector2i(6, 0)]:
				set_cell(0, cell, 0, tile)
		else:
			erase_cell(4, cell)
		if "down" in directions:
			if tile in [Vector2i(1, 2), Vector2i(1, 3)]:
				set_cell(2, cell, 0, tile)
		else:
			erase_cell(4, cell)
		if "right" in directions:
			if tile == Vector2i(7, 1):
				set_cell(2, cell, 0, tile)
		else:
			erase_cell(4, cell)
		if "left" in directions:
			if tile == Vector2i(0, 1):
				set_cell(2, cell, 0, tile)
		else:
			erase_cell(4, cell)


func dropItem(item, transform):
	var drop = item.instantiate()
	get_parent().add_child(drop)
	drop.global_transform = transform
