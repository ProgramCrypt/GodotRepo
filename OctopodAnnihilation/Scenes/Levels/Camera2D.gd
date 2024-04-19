extends Camera2D

@onready var playerStats = get_node("/root/ActivePlayerStats")

var snipersVision = false
var snipersVisionTimer = 0


func _ready():
	position = get_tree().get_nodes_in_group('player')[0].position
	zoom = Vector2(1.25, 1.25)
	if playerStats.playerTypeDict[playerStats.playerType].passiveAbility == "snipersVision":
		snipersVision = true
		zoom = Vector2(0.9, 0.9)


func _process(delta):
	var target = get_tree().get_nodes_in_group('player')[0].position
	var vector = target - position
	#var speed = (vector.x**2+vector.y**2)**(1/2)
	
	position.x += 3 * vector.x * delta
	position.y += 3 * vector.y * delta
	
	#zooms camera in/out
	'if snipersVision == true:
		if get_tree().get_first_node_in_group("player").velocity == Vector2(0, 0):
			snipersVisionTimer += delta
			if snipersVisionTimer >= 1 and zoom >= Vector2(0.8, 0.8):
				zoom -= (zoom-Vector2(0.7, 0.7)) * delta
		else:
			snipersVisionTimer = 0
			if zoom <= Vector2(1.25, 1.25):
				zoom += (Vector2(1.35, 1.35)-zoom) * delta'
