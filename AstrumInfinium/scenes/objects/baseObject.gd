extends RigidBody3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")


func _integrate_forces(state):
	state.apply_force(physicsHandler.globalGravity * physicsHandler.globalGravityDir * mass)
