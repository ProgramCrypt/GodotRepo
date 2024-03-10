extends Node

var damageType : int #0=ballistic, 1=laser, 2=plasma
var damage : float #value of health lost. cannot go below 1
var energyUse : float #value of energy used per shot or per second for lasers
var projectileRange : float #number of pixels until damage dropoff starts. cannot go below 100
var fireRate : float #time between shots / warm up time for shot
var accuracy : float #angle in degrees that projectiles can be fired
var projectileSpeed : float #pixels per second
var projectileSize : float #percentage set to 1 by default
var penetration : float #number of possible enemies hit. cannot go below 1
var effectsOnHit : Array

func initialize(stats : ProjectileWeaponStatList):
	damageType = stats.damageType
	damage = stats.damage
	energyUse = stats.energyUse
	projectileRange = stats.projectileRange
	fireRate = stats.fireRate
	accuracy = stats.accuracy
	projectileSpeed = stats.projectileSpeed
	projectileSize = stats.projectileSize
	penetration = stats.penetration
	effectsOnHit = stats.effectsOnHit

func setStatValue(stat, value):
	if stat == "damage":
		damage = value
	if stat == "energyUse":
		energyUse = value
	if stat == "projectileRange":
		projectileRange = value
	if stat == "fireRate":
		fireRate = value
	if stat == "accuracy":
		accuracy = value
	if stat == "projectileSpeed":
		projectileSpeed = value
	if stat == "projectileSize":
		projectileSize = value
	if stat == "penetration":
		penetration = value
	if stat == "effectsOnHit":
		effectsOnHit = value
	

func modifyStatValue(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "energyUse":
		energyUse += modifier
		energyUse = max(0.1, energyUse)
	if stat == "projectileRange":
		projectileRange += modifier
		projectileRange = max(100, projectileRange)
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
