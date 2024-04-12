extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")
#@onready var projectileWeaponStats = get_node("/root/ProjectileWeaponStats")

var shooter = null
var projectileProperties

var parentVelocity = Vector2(0, 0)
var speed = 0
var distanceTraveled = 0
var bodiesPassedThrough = 0

@onready var anim = $AnimatedSprite2D
var animTimer = 0
var dissipate = false

func _ready():
	anim.play("default")

func _physics_process(delta):
	position -= transform.x * speed * delta
	#position += parentVelocity/2 * delta
	distanceTraveled += speed * delta
	if distanceTraveled > projectileProperties["projectileRange"]:
		if dissipate == false:
			anim.play("dissipate")
			dissipate = true
		animTimer += delta
		#print(animTimer)
		if animTimer >= 0.5:
			queue_free()

#shooterProjectileProperties = {"baseDamage": var, "damageMultiplier": var, "range": var, "speed": var, "penetration": var, "projectileMultiplier": var, "effectsOnHit": Array}
func setShooter(shooterGroups, shooterProjectileProperties):
	projectileProperties = shooterProjectileProperties
	if "player" in shooterGroups:
		shooter = "player"
	elif "npc" in shooterGroups:
		shooter = "npc"
	else:
		shooter = "enemy"
	speed = projectileProperties["projectileSpeed"]
	parentVelocity = projectileProperties["parentVelocity"]
	$AnimatedSprite2D.scale = Vector2(projectileProperties["projectileSize"], projectileProperties["projectileSize"])
	$CollisionShape2D.scale = Vector2(projectileProperties["projectileSize"], projectileProperties["projectileSize"])

func _on_body_entered(body):
	#damage to mob
	if shooter == "player" or shooter == "npc":
		if body.is_in_group("player") == true or body.is_in_group("npc") == true:
			pass
		else:
			if body.is_in_group("enemy") == true:
				var plasmaResistance = body.getResistances()["plasmaResistance"]
				var damage = statModification.plasmaDamage(projectileProperties["damage"], plasmaResistance)
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
				var plasmaResistance = playerStats.plasmaResistance
				var damage = statModification.plasmaDamage(projectileProperties["damage"], plasmaResistance)
				playerStats.takeDamage(damage)
			bodiesPassedThrough += 1
			if body.is_in_group("player") == true:
				if bodiesPassedThrough >= projectileProperties["penetration"]:
					queue_free()
			else:
				queue_free()
