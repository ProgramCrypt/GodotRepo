extends Sprite2D

@onready var playerStats = get_node("/root/ActivePlayerStats")

var weaponType : String #"projectile" or "melee"
var damageType : int #0=ballistic, 1=laser, 2=plasma
var damage : float #value of health lost. cannot go below 1
var energyUse : float #value of energy used per shot or per second for lasers
var projectileRange : float #number of tiles. cannot go below 1
var fireRate : float #time between shots / warm up time for shot
var accuracy : float #angle in degrees that projectiles can be fired
var projectileSpeed : float #pixels per second
var projectileSize : float #percentage set to 1 by default
var penetration : float #number of possible enemies hit. cannot go below 1
var effectsOnHit : Array

var swingRange : float #number of pixels outward swing prjects
var swingAngle : float #number of degrees of width of swing
var swingRate : float #time between swings
var swingSpeed : float #time that a swing takes

func _ready():
	changeWeapon(playerStats.weapon1)

func initialize(stats : ProjectileWeaponStatList):
	weaponType = stats.weaponType
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

func changeWeapon(statDict):
	weaponType = statDict["weaponType"]
	damageType = statDict["damageType"]
	damage = statDict["damage"]
	energyUse = statDict["energyUse"]
	effectsOnHit = statDict["effectsOnHit"]
	if statDict["weaponType"] == "projectile":
		projectileRange = statDict["projectileRange"]
		fireRate = statDict["fireRate"]
		accuracy = statDict["accuracy"]
		projectileSpeed = statDict["projectileSpeed"]
		projectileSize = statDict["projectileSize"]
		penetration = statDict["penetration"]
		if statDict["damageType"] == 0:
			frame = 1
			$Muzzle.position = Vector2(-32, -7)
		if statDict["damageType"] == 1:
			frame = 3
			$Muzzle.position = Vector2(-26, -5)
		if statDict["damageType"] == 2:
			frame = 5
			$Muzzle.position = Vector2(-40, -3)
	if statDict["weaponType"] == "melee":
		swingRange = statDict["swingRange"]
		swingAngle = statDict["swingAngle"]
		swingRate = statDict["swingRate"]
		swingSpeed = statDict["swingSpeed"]
		if statDict["damageType"] == 0:
			frame = 7
		if statDict["damageType"] == 1:
			frame = 9

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

func applyUpgrade(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "energyUse":
		energyUse += modifier
		energyUse = max(0.1, energyUse)
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
