extends Node3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var shift


func shiftGravity():
	shift = $pointer.global_position - global_position
	$AudioStreamPlayer3D.play(3.2)
	physicsHandler.gravShift(shift)
