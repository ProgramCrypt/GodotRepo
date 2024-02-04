extends Node

var damageType : int #0=ballistic, 1=laser, 2=plasma
var damage : float #value of health lost. cannot go below 1
var range : float #number of tiles. cannot go below 1
var fireRate : float #time between shots / warm up time for shot
var projectileSpeed : float #pixels per second
var projectileSize : float #percentage set to 1 by default
var penetration : float #number of possible enemies hit. cannot go below 1
var projectilesPerShot : int #cannot go below 1
var effectsOnHit : Array

func initialize(stats : ProjectileWeaponStatList):
	damageType = stats.damageType
	damage = stats.damage
	range = stats.range
	fireRate = stats.fireRate
	projectileSpeed = stats.projectileSpeed
	projectileSize = stats.projectileSize
	penetration = stats.penetration
	projectilesPerShot = stats.projectilesPerShot
	effectsOnHit = stats.effectsOnHit

func setStatValue(stat, value):
	stat = value

func modifyStatValue(stat, modifier):
	stat += modifier
	if stat in ["damage", "range", "penetration", "projectilesPerShot"]:
		stat = max(1, stat)
