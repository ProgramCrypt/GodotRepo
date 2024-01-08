extends Camera2D


func _ready():
	position = get_tree().get_nodes_in_group('player')[0].position


func _process(delta):
	var target = get_tree().get_nodes_in_group('player')[0].position
	var vector = target - position
	#var speed = (vector.x**2+vector.y**2)**(1/2)
	
	position.x += 2 * vector.x * delta
	position.y += 2 * vector.y * delta
