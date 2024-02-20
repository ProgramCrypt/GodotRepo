extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")

func _on_body_entered(body):
	if body.is_in_group("player"):
		playerStats.modifyStatValue("currentScrap", 1)
		queue_free()
