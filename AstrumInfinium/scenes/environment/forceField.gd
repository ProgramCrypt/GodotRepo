extends StaticBody3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var knownGravity = Vector3(0, -1, 0)

var player
var mesh


func _ready():
	physicsHandler.gravityChanged.connect(setField, 1)
	call_deferred('setField')
	player = get_tree().get_first_node_in_group('player')
	mesh = $MeshInstance3D


func _process(_delta):
	var closestPoint = getClosestPointOnPrism(player.global_transform.origin) #global_transform.origin == global_position I think
	$AudioStreamPlayer3D.global_transform.origin = closestPoint


func getClosestPointOnPrism(targetPosition):
	var bounds = mesh.get_aabb()
	var minDistance = INF
	var closestPoint = Vector3()

	# Loop through each face of the rectangular prism
	for axis in range(3):
		for direction in [-1, 1]:
			var planePos = mesh.global_position + bounds.size * axisToVector(axis, direction) #defines a given plane out of the 6 total
			var planeNormal = axisToVector(axis, direction)
			var pointOnPlane = projectPointOnPlane(targetPosition, planePos, planeNormal)
			var clampedPoint = clampPointInAABB(pointOnPlane, bounds) #clamps the projected point within the confines of the mesh's plane segment (instead of an infinite plane)
			var distance = targetPosition.distance_to(clampedPoint)
			if distance < minDistance:
				minDistance = distance
				closestPoint = clampedPoint
	return closestPoint# + mesh.global_position


func axisToVector(axis, direction):
	var vec = Vector3()
	vec[axis] = direction
	return vec


func projectPointOnPlane(point, planePos, planeNormal):
	var toPoint = point - planePos
	var distance = toPoint.dot(planeNormal) #uses dot product so that the distance is reduced if the point is near the plane but far from its normal vector (which is centered at the plane's origin)
	return point - planeNormal * distance #projects point onto infinite plane


func clampPointInAABB(point, aabb):
	return Vector3(
		clamp(point.x, aabb.position.x + mesh.global_position.x, aabb.position.x + aabb.size.x + mesh.global_position.x),
		clamp(point.y, aabb.position.y + mesh.global_position.y, aabb.position.y + aabb.size.y + mesh.global_position.y),
		clamp(point.z, aabb.position.z + mesh.global_position.z, aabb.position.z + aabb.size.z + mesh.global_position.z)
	)


func setField():
	#print(abs(physicsHandler.globalGravityDir.dot(global_transform.basis.y)))
	if abs(physicsHandler.globalGravityDir.dot(global_transform.basis.y)) >= 0.93:
		$CollisionShape3D.disabled = true
		$MeshInstance3D.mesh.material.set_shader_parameter('albedo', Color(0.9, 0.9, 1.0, 1.0))
		#$MeshInstance3D2.mesh.material.set_shader_parameter('albedo', Color(0.9, 0.9, 1.0, 1.0))
	else:
		$CollisionShape3D.disabled = false
		$MeshInstance3D.mesh.material.set_shader_parameter('albedo', Color(1.0, 0.75, 0.7, 0.85))
		#$MeshInstance3D2.mesh.material.set_shader_parameter('albedo', Color(1.0, 0.75, 0.7, 0.85))
