extends Node

signal gravityChanged()

var globalGravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var globalGravityDir = Vector3(0, -1, 0)


func gravShift(dir):
	globalGravityDir = dir
	gravityChanged.emit()
