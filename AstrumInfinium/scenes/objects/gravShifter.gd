extends Node3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var shift


func _ready():
	$Timer.one_shot = true

func shiftGravity():
	shift = $pointer.global_position - global_position
	print(shift)
	$AudioStreamPlayer3D.play()
	$Timer.start()

func _on_timer_timeout():
	physicsHandler.globalGravityDir = shift
