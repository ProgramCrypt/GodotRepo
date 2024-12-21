extends Node3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var shift
var outline = false
var outlineTimer = 0


func _process(delta):
	if outline == true:
		$"Tech-4/outlineMesh".visible = true
		outlineTimer += delta
		if outlineTimer >= 0.1:
			outline = false
	else:
		$"Tech-4/outlineMesh".visible = false

func shiftGravity():
	shift = $pointer.global_position - global_position
	$AudioStreamPlayer3D.play(3.2)
	physicsHandler.gravShift(shift)
