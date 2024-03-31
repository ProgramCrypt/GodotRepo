extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")
#@onready var projectileWeaponStats = get_node("/root/ProjectileWeaponStats")

var shooter = null
var projectileProperties = {"damage": 0, "projectileRange": 0, "projectileSpeed": 0, "penetration": 0, "effectsOnHit": 0}

var speed = 0
var distanceTraveled = 0
var bodiesPassedThrough = 0

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("default")

func _physics_process(delta):
	position -= transform.x * speed * delta
	distanceTraveled += speed * delta
	if distanceTraveled > projectileProperties["projectileRange"]:
		projectileProperties["damage"] -= (distanceTraveled - projectileProperties["projectileRange"]) * 0.01 * delta
		if projectileProperties["damage"] <= 0:
			queue_free()

#shooterProjectileProperties = {"damage": var, "range": var, "speed": var, "penetration": var, "projectileMultiplier": var, "effectsOnHit": Array}
func setShooter(shooterGroups, shooterProjectileProperties):
	projectileProperties = shooterProjectileProperties
	if "player" in shooterGroups:
		shooter = "player"
	elif "npc" in shooterGroups:
		shooter = "npc"
	else:
		shooter = "enemy"
	speed = projectileProperties["projectileSpeed"]

func _on_body_entered(body):
	#damage to mob
	if shooter == "player" or shooter == "npc":
		if body.is_in_group("player") == true or body.is_in_group("npc") == true:
			pass
		else:
			if body.is_in_group("enemy") == true:
				var ballisticResistance = body.getResistances()["ballisticResistance"]
				var damage = statModification.ballisticDamage(projectileProperties["damage"], ballisticResistance)
				body.takeDamage(damage)
			bodiesPassedThrough += 1
			if body.is_in_group("enemy") == true:
				if bodiesPassedThrough >= projectileProperties["penetration"]:
					queue_free()
			else:
				queue_free()
	
	#damage to player
	if shooter == "enemy":
		if body.is_in_group("enemy"):
			pass
		else:
			if body.is_in_group("player") == true:
				var ballisticResistance = playerStats.ballisticResistance
				var damage = statModification.ballisticDamage(projectileProperties["damage"], ballisticResistance)
				playerStats.takeDamage(damage)
			bodiesPassedThrough += 1
			if body.is_in_group("player") == true:
				if bodiesPassedThrough >= projectileProperties["penetration"]:
					queue_free()
			else:
				queue_free()
