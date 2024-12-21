extends Node3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

@export var timerLength = 3.2

var shift
var outline = false
var outlineTimer = 0

func _ready():
	$Timer.one_shot = true

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
	$AudioStreamPlayer3D.play()
	$Timer.start(timerLength)

func _on_timer_timeout():
	physicsHandler.gravShift(shift)
