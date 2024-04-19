extends RayCast2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var shooter = null
var projectileProperties
var damageTimer = 1.0
var missTimer = 0

#shooterProjectileProperties = {"damage": var, "range": var, "speed": var, "penetration": var, "effectsOnHit": Array}
func setShooter(shooterGroups, shooterProjectileProperties):
	projectileProperties = shooterProjectileProperties
	if "player" in shooterGroups:
		shooter = "player"
	elif "npc" in shooterGroups:
		shooter = "npc"
	else:
		shooter = "enemy"
	
	if projectileProperties["damage"] <= 0.15:
		$Line2D.set_default_color(Color(1, 0.2, 0.2, 1)) #red
	elif projectileProperties["damage"] <= 0.25:
		$Line2D.set_default_color(Color(1, 1, 0.3, 1)) #yellow
	elif projectileProperties["damage"] <= 0.35:
		$Line2D.set_default_color(Color(0.2, 1, 0.2, 1)) #green
	elif projectileProperties["damage"] <= 0.45:
		$Line2D.set_default_color(Color(0, 0.9, 1, 1)) #blue
	elif projectileProperties["damage"] <= 0.55:
		$Line2D.set_default_color(Color(0.7, 0.4, 1, 1)) #violet
	elif projectileProperties["damage"] >= 0.55:
		$Line2D.set_default_color(Color(0.7, 0.5, 1, 1)) #UV


func _physics_process(delta):
	#create laser visual
	if get_collider() != null:
		var laserVec = get_collision_point() - global_position
		laserVec = Vector2(0 - laserVec.length(), 0)
		$Line2D.set_point_position(1, laserVec)
	else:
		$Line2D.set_point_position(1, Vector2(-1500, 0))
	
	#damage to mob
	if shooter == "player" or shooter == "npc":
		if get_collider() != null:
			if get_collider().is_in_group("enemy") == true:
				var laserResistance = get_collider().getResistances()["laserResistance"]
				var damage = statModification.laserDamage(damageTimer, projectileProperties["damage"] * 1.5, laserResistance) * delta
				get_collider().takeDamage(damage)
				damageTimer += delta
				missTimer = 0
			else:
				missTimer += delta
				if missTimer >= 1:
					damageTimer = 1.0
		else:
			missTimer += delta
			if missTimer >= 1:
				damageTimer = 1.0
	
	#damage to player
	if shooter == "enemy":
		if get_collider() != null:
			if get_collider().is_in_group("player") == true:
				var laserResistance = playerStats.laserResistance
				var damage = statModification.laserDamage(damageTimer, projectileProperties["damage"], laserResistance) * delta
				playerStats.takeDamage(damage)
				damageTimer += delta
			else:
				damageTimer = 1.0
		else:
			damageTimer = 1.0
