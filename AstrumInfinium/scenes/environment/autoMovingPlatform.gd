extends Node3D

@export var navigationPoints = [Vector3(0, 0, 0), Vector3(1, 0, 0)]
@export var speed = 1.0
@export var pauseDuration = 0.8

var nextPoint
var pauseTimer = 0
var moving = true


func _ready():
	global_position = navigationPoints[0]
	nextPoint = navigationPoints[1]


func _physics_process(delta):
	if moving == true:
		var direction = nextPoint - global_position
		direction /= direction.length()
		global_position += direction * speed * delta
	
	if (nextPoint - global_position).length() < 0.001:
		moving = false
		pauseTimer += delta
		if pauseTimer >= pauseDuration:
			var index = navigationPoints.find(nextPoint)
			if navigationPoints.size() == index + 1:
				index = 0
			else:
				index += 1
			nextPoint = navigationPoints[index]
			pauseTimer = 0
			moving = true
