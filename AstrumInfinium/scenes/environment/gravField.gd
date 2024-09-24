extends Area3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

@export var gravDirection = Vector3(0, 0, -1)


func _on_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		if gravDirection.dot(physicsHandler.globalGravityDir) <= 0.85:
			physicsHandler.gravShift(gravDirection + Vector3(0.00001, 0.00001, 0.00001))
