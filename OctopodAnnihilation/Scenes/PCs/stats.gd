extends Node2D

signal healthChanged()
signal healthDepleted()
signal energyChanged()
signal energyDepleted()

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
		stat = max(0, stat)
	if stat == "strength":
		strength += modifier
		stat = max(0, stat)
	if stat == "rateOfFire":
		rateOfFire += modifier
		stat = max(0, stat)
	if stat == "gunAccuracy":
		gunAccuracy += modifier
		stat = max(0, stat)
	if stat == "ballisticResistance":
		ballisticResistance += modifier
		stat = min(100, stat)
	if stat == "laserResistance":
		laserResistance += modifier
		stat = min(100, stat)
	if stat == "plasmaResistance":
		plasmaResistance += modifier
		stat = min(100, stat)
	if stat == "fireResistance":
		fireResistance += modifier
		stat = min(100, stat)
	if stat == "bleedingResistance":
		bleedingResistance += modifier
		stat = min(100, stat)
	if stat == "explosionResistance":
		explosionResistance += modifier
		stat = min(100, stat)
	if stat == "slowResistance":
		slowResistance += modifier
		stat = min(100, stat)
	if stat == "stunResistance":
		stunResistance += modifier
		stat = min(100, stat)
