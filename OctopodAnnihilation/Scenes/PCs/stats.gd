extends Node2D

signal healthChanged()
signal healthDepleted()

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

func setStatValue(stat, value):
	stat = value

func modifyStatValue(stat, modifier):
	if stat in ["speed", "strength", "rateOfFire", "gunAccuracy"]:
		stat += modifier
		stat = max(0, stat)
	elif stat in ["ballisticResistance", "laserResistance", "plasmaResistance", "fireResistance", "explosionResistance", "slowResistance", "stunResistance"]:
		stat += modifier
		stat = min(100, stat)
	else:
		stat += modifier
