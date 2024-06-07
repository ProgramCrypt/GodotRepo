extends TileMap

@onready var sceneManager = get_node("/root/SceneManager")

@export var chimeraSoldier: PackedScene
@export var octopodEngineer: PackedScene

var tables = []
var servers = []
var vats = []

func _ready():
	
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
			if spawnerType == Vector2i(0, 2):
				var enemy = chimeraSoldier.instantiate()
				add_child(enemy)
				enemy.position = map_to_local(cell)
				enemyArray.append(enemy)
				roomDifficulty -= 1
			if spawnerType == Vector2i(4, 2):
				var enemy = octopodEngineer.instantiate()
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
		
		if "up" in directions and cell.y <= 5:
			if tile in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0), Vector2i(6, 0), Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2), Vector2i(4, 2), Vector2i(5, 2), Vector2i(6, 2), Vector2i(7, 2), Vector2i(8, 2), Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3), Vector2i(6, 3), Vector2i(7, 3), Vector2i(8, 3), Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4), Vector2i(4, 4), Vector2i(5, 4), Vector2i(6, 4), Vector2i(7, 4), Vector2i(8, 4), Vector2i(9, 4)]:
				set_cell(0, cell, 4, tile)
			elif tile in [Vector2i(7, 6)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(4, cell)
		if "down" in directions and cell.y >= 9:
			if tile in [Vector2i(7, 5), Vector2i(7, 6), Vector2i(6, 5), Vector2i(6, 6), Vector2i(6, 7), Vector2i(8, 5), Vector2i(8, 6), Vector2i(8, 7), Vector2i(9, 5), Vector2i(9, 6), Vector2i(9, 7)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(4, cell)
		if "right" in directions and cell.x >= 9:
			if tile in [Vector2i(8, 5), Vector2i(8, 6), Vector2i(8, 7), Vector2i(7, 6)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(4, cell)
		if "left" in directions and cell.x <= 5:
			if tile in [Vector2i(9, 5), Vector2i(9, 6), Vector2i(9, 7), Vector2i(7, 6)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(4, cell)


func dropItem(item, transform):
	var drop = item.instantiate()
	get_parent().add_child(drop)
	drop.global_transform = transform
