extends Sprite2D

@onready var playerStats = get_node("/root/ActivePlayerStats")

var damageType : int #0=ballistic, 1=laser, 2=plasma
var damage : float #value of health lost. cannot go below 1
var energyUse : float #value of energy used per shot or per second for lasers
var projectileRange : float #number of tiles. cannot go below 1
var fireRate : float #time between shots / warm up time for shot
var speed : float #pixels per second
var size : float #percentage set to 1 by default
var penetration : float #number of possible enemies hit. cannot go below 1
var projectilesPerShot : int #cannot go below 1
var effectsOnHit : Array


func _ready():
	changeWeapon(playerStats.weapon1)

func initialize(stats : ProjectileWeaponStatList):
	damageType = stats.damageType
	damage = stats.damage
	energyUse = stats.energyUse
	projectileRange = stats.projectileRange
	fireRate = stats.fireRate
	speed = stats.speed
	size = stats.size
	penetration = stats.penetration
	projectilesPerShot = stats.projectilesPerShot
	effectsOnHit = stats.effectsOnHit

func changeWeapon(statDict):
	damageType = statDict["damageType"]
	damage = statDict["damage"]
	energyUse = statDict["energyUse"]
	projectileRange = statDict["projectileRange"]
	fireRate = statDict["fireRate"]
	speed = statDict["speed"]
	size = statDict["size"]
	penetration = statDict["penetration"]
	projectilesPerShot = statDict["projectilesPerShot"]
	effectsOnHit = statDict["effectsOnHit"]

func setStatValue(stat, value):
	if stat == "damage":
		damage = value
	if stat == "projectileRange":
		projectileRange = value
	if stat == "fireRate":
		fireRate = value
	if stat == "speed":
		speed = value
	if stat == "size":
		size = value
	if stat == "penetration":
		penetration = value
	if stat == "projectilesPerShot":
		projectilesPerShot = value
	if stat == "effectsOnHit":
		effectsOnHit = value

func modifyStatValue(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "projectileRange":
		projectileRange += modifier
		projectileRange = max(1, projectileRange)
	if stat == "fireRate":
		fireRate += modifier
	if stat == "speed":
		speed += modifier
	if stat == "size":
		size += modifier
	if stat == "penetration":
		penetration += modifier
		penetration = max(1, penetration)
	if stat == "projectilesPerShot":
		projectilesPerShot += modifier
		projectilesPerShot = max(1, projectilesPerShot)
	if stat == "effectsOnHit":
		effectsOnHit.append(modifier)

func applyUpgrade(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "projectileRange":
		projectileRange += modifier
		projectileRange = max(1, projectileRange)
	if stat == "fireRate":
		fireRate += modifier
	if stat == "speed":
		speed += modifier
	if stat == "size":
		size += modifier
	if stat == "penetration":
		penetration += modifier
		penetration = max(1, penetration)
	if stat == "projectilesPerShot":
		projectilesPerShot += modifier
		projectilesPerShot = max(1, projectilesPerShot)
	if stat == "effectsOnHit":
		effectsOnHit.append(modifier)
