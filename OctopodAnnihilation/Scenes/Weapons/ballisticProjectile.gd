extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")
#@onready var projectileWeaponStats = get_node("/root/ProjectileWeaponStats")

var shooter = null
var projectileProperties

var speed = 0

func _physics_process(delta):
	position -= transform.x * speed * delta

#shooterProjectileProperties = {"baseDamage": var, "damageMultiplier": var, "range": var, "speed": var, "penetration": var, "projectileMultiplier": var, "effectsOnHit": Array}
func setShooter(shooterGroups, shooterProjectileProperties):
	projectileProperties = shooterProjectileProperties
	if "player" in shooterGroups:
		shooter = "player"
	elif "npc" in shooterGroups:
		shooter = "npc"
	else:
		shooter = "enemy"
	speed = projectileProperties["speed"]

func _on_body_entered(body):
	#damage to mob
	if shooter == "player" or shooter == "npc":
		if body.is_in_group("player"):
			pass
		else:
			if body.is_in_group("enemy") == true:
				var ballisticResistance = body.getResistances()["ballisticResistance"]
				var damage = statModification.ballisticDamage({"ballisticResistance": ballisticResistance, "damageMultiplier": projectileProperties["damageMultiplier"]}, projectileProperties["baseDamage"])
				body.takeDamage(damage)
			queue_free()
	
	#damage to player
	if shooter == "enemy":
		if body.is_in_group("enemy"):
			pass
		else:
			if body.is_in_group("player") == true:
				var ballisticResistance = playerStats.ballisticResistance
				var damage = statModification.ballisticDamage({"ballisticResistance": ballisticResistance, "damageMultiplier": projectileProperties["damageMultiplier"]}, projectileProperties["baseDamage"])
				playerStats.takeDamage(damage)
			queue_free()
