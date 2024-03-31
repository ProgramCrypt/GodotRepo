extends TileMap


func setRoom(cell, type):
	if type == "normal":
		set_cell(0, cell, 0, Vector2i(0, 0))
	if type == "derelict":
		set_cell(0, cell, 0, Vector2i(1, 0))
	if type == "spawn":
		set_cell(0, cell, 0, Vector2i(2, 0))
	if type == "exit":
		set_cell(0, cell, 0, Vector2i(3, 0))
	if type == "boss":
		set_cell(0, cell, 0, Vector2i(0, 1))
