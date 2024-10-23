@tool
extends Node2D


func _process(delta):
	rotation += delta * PI * 0.1
