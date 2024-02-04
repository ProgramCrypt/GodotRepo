extends Area2D

var shooter = null

@export var speed = 800

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

func _physics_process(delta):
	position -= transform.x * speed * delta

func setShooter(shooterGroups):
	if "player" in shooterGroups:
		shooter = "player"
	else:
		shooter = "mob"

func _on_body_entered(body):
	if shooter == "player":
		if body.is_in_group("player"):
			pass
		else:
			if body.is_in_group("mobs"):
				var damage = statModification.ballisticDamage()
				body.takeDamage(damage)
			queue_free()
	if shooter == "mob":
		if body.is_in_group("mob"):
			pass
		else:
			if body.is_in_group("player"):
				var damage = statModification.ballisticDamage()
				playerStats.takeDamage(damage)
			queue_free()
