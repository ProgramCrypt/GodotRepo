extends Node3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

@export var timerLength = 3.2

var shift


func _ready():
	$Timer.one_shot = true

func shiftGravity():
	shift = $pointer.global_position - global_position
	$AudioStreamPlayer3D.play()
	$Timer.start(timerLength)

func _on_timer_timeout():
	physicsHandler.gravShift(shift)
