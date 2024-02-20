extends Node2D

signal healthChanged()
signal healthDepleted()
signal energyChanged()
signal energyDepleted()
signal scrapChanged()
signal playerWeaponsSet(weapon)

@export var playerType : Resource
@export var startingWeapon1 : Resource
@export var startingWeapon2 : Resource
var weapon1 = {}
var weapon2 = {}

@export var energyRegenRate = 5 #points per second
var energyDepletionTimer : float

var modifiers = {}

var maxHealth : float
var currentHealth : float
var maxEnergy : float
var currentEnergy : float
var speed : float
var strength : float
var rateOfFire : float
var gunAccuracy : float
var ballisticResistance : float
var laserResistance : float
var plasmaResistance : float
var bleedingResistance : float
var fireResistance : float
var explosionResistance : float
var slowResistance : float
var stunResistance : float

var currentScrap : int


func _ready():
	initialize(playerType)
	
	saveWeapon(startingWeapon1, weapon1)
	saveWeapon(startingWeapon2, weapon2)
	#emit_signal("playerWeaponsSet", weapon1)

func initialize(stats : PlayerStats):
	maxHealth = stats.maxHealth
	currentHealth = stats.currentHealth
	maxEnergy = stats.maxEnergy
	currentEnergy = stats.currentEnergy
	speed = stats.speed
	strength = stats.strength
	rateOfFire = stats.rateOfFire
	gunAccuracy = stats.gunAccuracy
	ballisticResistance = stats.ballisticResistance
	laserResistance = stats.laserResistance
	plasmaResistance = stats.plasmaResistance
	bleedingResistance = stats.bleedingResistance
	fireResistance = stats.fireResistance
	explosionResistance = stats.explosionResistance
	slowResistance = stats.slowResistance
	stunResistance = stats.stunResistance
	
	currentScrap = 0

func _physics_process(delta):
	if energyDepletionTimer == 0:
		regenEnergy(energyRegenRate * delta)
	else:
		energyDepletionTimer -= delta
		energyDepletionTimer = max(energyDepletionTimer, 0)

func setMaxHealth(value):
	maxHealth = max(0, value)

func setMaxEnergy(value):
	maxEnergy = max(0, value)

func takeDamage(hit):
	currentHealth -= hit
	currentHealth = max(0, currentHealth)
	emit_signal("healthChanged")
	if currentHealth == 0:
		emit_signal("healthDepleted")

func heal(amount):
	currentHealth += amount
	currentHealth = min(currentHealth, maxHealth)
	emit_signal("healthChanged")

func useEnergy(amount):
	currentEnergy -= amount
	currentEnergy = max(currentEnergy, 0)
	if currentEnergy == 0:
		energyDepletionTimer = 1.0
		emit_signal("energyDepleted")
	emit_signal("energyChanged")

func regenEnergy(amount):
	currentEnergy += amount
	currentEnergy = min(currentEnergy, maxEnergy)
	emit_signal("energyChanged")

func saveWeapon(stats : ProjectileWeaponStatList, weaponDict):
	weaponDict["damageType"] = stats.damageType
	weaponDict["damage"] = stats.damage
	weaponDict["energyUse"] = stats.energyUse
	weaponDict["projectileRange"] = stats.projectileRange
	weaponDict["fireRate"] = stats.fireRate
	weaponDict["speed"] = stats.speed
	weaponDict["size"] = stats.size
	weaponDict["penetration"] = stats.penetration
	weaponDict["projectilesPerShot"] = stats.projectilesPerShot
	weaponDict["effectsOnHit"] = stats.effectsOnHit

func setStatValue(stat, value):
	if stat == "maxHealth":
		maxHealth = value
	if stat == "currentHealth":
		currentHealth = value
	if stat == "maxEnergy":
		maxEnergy = value
	if stat == "currentEnergy":
		currentEnergy = value
	if stat == "speed":
		speed = value
	if stat == "strength":
		strength = value
	if stat == "rateOfFire":
		rateOfFire = value
	if stat == "gunAccuracy":
		gunAccuracy = value
	if stat == "ballisticResistance":
		ballisticResistance = value
	if stat == "laserResistance":
		laserResistance = value
	if stat == "plasmaResistance":
		plasmaResistance = value
	if stat == "fireResistance":
		fireResistance = value
	if stat == "bleedingResistance":
		bleedingResistance = value
	if stat == "explosionResistance":
		explosionResistance = value
	if stat == "slowResistance":
		slowResistance = value
	if stat == "stunResistance":
		stunResistance = value
	if stat == "currentScrap":
		currentScrap = value

func modifyStatValue(stat, modifier):
	if stat == "maxHealth":
		maxHealth += modifier
	if stat == "currentHealth":
		currentHealth += modifier
	if stat == "maxEnergy":
		maxEnergy += modifier
	if stat == "currentEnergy":
		currentEnergy += modifier
	if stat == "speed":
		speed += modifier
		speed = max(0, speed)
	if stat == "strength":
		strength += modifier
		strength = max(0, strength)
	if stat == "rateOfFire":
		rateOfFire += modifier
		rateOfFire = max(0, rateOfFire)
	if stat == "gunAccuracy":
		gunAccuracy += modifier
		gunAccuracy = max(0, gunAccuracy)
	if stat == "ballisticResistance":
		ballisticResistance += modifier
		ballisticResistance = min(100, ballisticResistance)
	if stat == "laserResistance":
		laserResistance += modifier
		laserResistance = min(100, laserResistance)
	if stat == "plasmaResistance":
		plasmaResistance += modifier
		plasmaResistance = min(100, plasmaResistance)
	if stat == "fireResistance":
		fireResistance += modifier
		fireResistance = min(100, fireResistance)
	if stat == "bleedingResistance":
		bleedingResistance += modifier
		bleedingResistance = min(100, bleedingResistance)
	if stat == "explosionResistance":
		explosionResistance += modifier
		explosionResistance = min(100, explosionResistance)
	if stat == "slowResistance":
		slowResistance += modifier
		slowResistance = min(100, slowResistance)
	if stat == "stunResistance":
		stunResistance += modifier
		stunResistance = min(100, stunResistance)
	if stat == "currentScrap":
		currentScrap += modifier
		currentScrap = max(0, currentScrap)
		emit_signal("scrapChanged")
