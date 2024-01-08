extends TileMap

@export var propCollisionBox: PackedScene

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
				
	

func changeTile(cell, newTile):
	set_cell(1, cell, 1, newTile) #this line is the cause of the lag
