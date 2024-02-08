extends RayCast2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var shooter = null
var projectileProperties
var timer = 1.0

#shooterProjectileProperties = {"baseDamage": var, "damageMultiplier": var, "range": var, "speed": var, "penetration": var, "projectileMultiplier": var, "effectsOnHit": Array}
func setShooter(shooterGroups, shooterProjectileProperties):
	projectileProperties = shooterProjectileProperties
	if "player" in shooterGroups:
		shooter = "player"
	elif "npc" in shooterGroups:
		shooter = "npc"
	else:
		shooter = "enemy"

func _physics_process(delta):
	#create laser visual
	var laserVec = get_collision_point() - global_position
	laserVec = Vector2(0 - laserVec.length(), 0)
	$Line2D.set_point_position(1, laserVec)
	
	#damage to mob
	if shooter == "player" or shooter == "npc":
		if get_collider().is_in_group("enemy") == true:
			var laserResistance = get_collider().getResistances()["laserResistance"]
			var damage = statModification.laserDamage({"laserResistance": laserResistance, "damageMultiplier": projectileProperties["damageMultiplier"]}, timer, projectileProperties["baseDamage"]) * delta
			get_collider().takeDamage(damage)
			timer += delta
		else:
			timer = 1.0
	
	#damage to player
	if shooter == "enemy":
		if get_collider().is_in_group("player") == true:
			var laserResistance = playerStats.laserResistance
			var damage = statModification.laserDamage({"laserResistance": laserResistance, "damageMultiplier": projectileProperties["damageMultiplier"]}, timer, projectileProperties["baseDamage"]) * delta
			playerStats.takeDamage(damage)
			timer += delta
		else:
			timer = 1.0
