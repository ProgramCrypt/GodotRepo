extends TileMap

#@export var player: PackedScene
@export var propCollisionBox: PackedScene

var tables = []
var servers = []
var vats = []

func _ready():
	'var p = player.instantiate()
	get_tree().root.call_deferred("add_child", p)
	p.position = Vector2i((get_parent().gridLen/2),(get_parent().gridLen/2)+100)'
	
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


func changeTile(cell, newTile):
	set_cell(1, cell, 1, newTile) #this line is the cause of the lag


func fillPassageways(directions):
	for cell in get_used_cells(3):
		var tile = get_cell_atlas_coords(3, cell)
		
		if "up" in directions and cell.y <= 5:
			if tile in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0), Vector2i(6, 0), Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2), Vector2i(4, 2), Vector2i(5, 2), Vector2i(6, 2), Vector2i(7, 2), Vector2i(8, 2), Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3), Vector2i(6, 3), Vector2i(7, 3), Vector2i(8, 3), Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4), Vector2i(4, 4), Vector2i(5, 4), Vector2i(6, 4), Vector2i(7, 4), Vector2i(8, 4), Vector2i(9, 4)]:
				set_cell(0, cell, 4, tile)
			elif tile in [Vector2i(7, 6)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(3, cell)
		if "down" in directions and cell.y >= 9:
			if tile in [Vector2i(7, 5), Vector2i(7, 6), Vector2i(6, 5), Vector2i(6, 6), Vector2i(6, 7), Vector2i(8, 5), Vector2i(8, 6), Vector2i(8, 7), Vector2i(9, 5), Vector2i(9, 6), Vector2i(9, 7)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(3, cell)
		if "right" in directions and cell.x >= 9:
			if tile in [Vector2i(8, 5), Vector2i(8, 6), Vector2i(8, 7), Vector2i(7, 6)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(3, cell)
		if "left" in directions and cell.x <= 5:
			if tile in [Vector2i(9, 5), Vector2i(9, 6), Vector2i(9, 7), Vector2i(7, 6)]:
				set_cell(2, cell, 4, tile)
		else:
			erase_cell(3, cell)
