extends Sprite2D

var damageType : int = 1 #0=hammer, 1=shield
var damage : float = 8 #value of health lost
var projectileRange : float #number of tiles. cannot go below 1
var fireRate : float #time between shots / warm up time for shot
var accuracy : float #angle in degrees that projectiles can be fired
var projectileSpeed : float #pixels per second
var projectileSize : float #percentage set to 1 by default
var penetration : float #number of possible enemies hit. cannot go below 1
var effectsOnHit : Array

func initialize(stats):
	damageType = stats.damageType
	damage = stats.damage
	projectileRange = stats.projectileRange
	fireRate = stats.fireRate
	accuracy = stats.accuracy
	projectileSpeed = stats.projectileSpeed
	projectileSize = stats.projectileSize
	penetration = stats.penetration
	effectsOnHit = stats.effectsOnHit


func modifyStatValue(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "projectileRange":
		projectileRange += modifier
		projectileRange = max(1, projectileRange)
	if stat == "fireRate":
		fireRate += modifier
	if stat == "accuracy":
		accuracy += modifier
		accuracy = max(0, accuracy)
	if stat == "projectileSpeed":
		projectileSpeed += modifier
	if stat == "projectileSize":
		projectileSize += modifier
	if stat == "penetration":
		penetration += modifier
		penetration = max(1, penetration)
	if stat == "effectsOnHit":
		effectsOnHit.append(modifier)
