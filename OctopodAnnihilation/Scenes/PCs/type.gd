extends Node2D

class_name Type


#@onready var stats = $stats
'@onready var playerStats = get_node("/root/ActivePlayerStats")

@export var playerType : Resource

func _ready():
	playerStats.initialize(playerType)
	print("typeReady ", playerStats.currentHealth)'
