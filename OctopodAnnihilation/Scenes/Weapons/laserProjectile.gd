extends RayCast2D

func _physics_process(_delta):
	var laserVec = get_collision_point() - global_position
	#print(global_position)
	laserVec = Vector2(0 - laserVec.length(), 0)
	$Line2D.set_point_position(1, laserVec)
