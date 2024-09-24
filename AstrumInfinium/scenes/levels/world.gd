extends Node3D

var player


func _ready():
	player = get_tree().get_first_node_in_group('player')
	player.healthChanged.connect(updateVignette)


func updateVignette(health):
	$HUD/vignette.material.set_shader_parameter('multiplier', pow(1.214814, health)/10)
	$HUD/vignette.material.set_shader_parameter('softness', pow(1.214814, health)/10 + 0.3)
