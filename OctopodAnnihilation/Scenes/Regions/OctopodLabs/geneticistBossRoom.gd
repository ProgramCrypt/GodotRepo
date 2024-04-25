extends TileMap

@onready var sceneManager = get_node("/root/SceneManager")

@export var forceField : PackedScene
@export var geneticist : PackedScene
@export var chimeraLabGrunt : PackedScene

var openPassages = []
var forceFieldsSpawned = false


func _ready():
	#geneticist spawning
	for cell in get_used_cells(3):
		var geneticistBoss = geneticist.instantiate()
		add_child(geneticistBoss)
		geneticistBoss.position = map_to_local(cell)


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
			if "up" not in openPassages:
				openPassages.append("up")
		if "down" in directions:
			if tile in [Vector2i(1, 2), Vector2i(1, 3)]:
				set_cell(2, cell, 0, tile)
		else:
			erase_cell(4, cell)
			if "down" not in openPassages:
				openPassages.append("down")
		if "right" in directions:
			if tile == Vector2i(7, 1):
				set_cell(2, cell, 0, tile)
		else:
			erase_cell(4, cell)
			if "right" not in openPassages:
				openPassages.append("right")
		if "left" in directions:
			if tile == Vector2i(0, 1):
				set_cell(2, cell, 0, tile)
		else:
			erase_cell(4, cell)
			if "left" not in openPassages:
				openPassages.append("left")


func dropItem(item, transform):
	var drop = item.instantiate()
	get_parent().add_child(drop)
	drop.global_transform = transform


func spawnEnemy(item, position):
	var enemy = item.instantiate()
	call_deferred("add_child", enemy)
	enemy.call_deferred("setPosition", position)
	#add_child(enemy)
	#enemy.global_position = position


func removeForceFields():
	for child in get_children():
		if child.is_in_group("forceField"):
			child.queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and forceFieldsSpawned == false:
		forceFieldsSpawned = true
		for passage in openPassages:
			var field = forceField.instantiate()
			call_deferred("add_child", field)
			#add_child(field)
			
			if passage == "up":
				field.call_deferred("setPosition", Vector2(750, 50))
				#field.position = Vector2(750, 50)
			if passage == "down":
				field.call_deferred("setPosition", Vector2(750, 1450))
				#field.position = Vector2(750, 1450)
			if passage == "right":
				field.call_deferred("setPosition", Vector2(1450, 750))
				#field.position = Vector2(1450, 750)
			if passage == "left":
				field.call_deferred("setPosition", Vector2(50, 750))
				#field.position = Vector2(50, 750)
