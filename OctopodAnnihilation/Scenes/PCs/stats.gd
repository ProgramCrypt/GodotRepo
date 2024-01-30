extends Node2D

signal healthChanged(newHealth)
signal healthDepleted()

var modifiers = {}

var maxHealth : int
var currentHealth : int
var maxEnergy : int
var currentEnergy : int
var speed : int
var strength : int
var rateOfFire : int
var gunAccuracy : int
var ballisticResistance : int
var laserResistance : int
var plasmaResistance : int
var bleedingResistance : int
var fireResistance : int
var explosionResistance : int
var slowResistance : int
var stunResistance : int

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
	currentHealth -= hit.damage
	currentHealth = max(0, currentHealth)
	emit_signal("healthChanged", currentHealth)
	if currentHealth == 0:
		emit_signal("healthDepleted")

func heal(amount):
	currentHealth += amount
	currentHealth = min(currentHealth, maxHealth)
	emit_signal("healthChanged", currentHealth)

func setStatValue(stat, value):
	stat = value

func modifyStatValue(stat, modifier):
	if stat in ["speed", "strength", "rateOfFire", "gunAccuracy"]:
		stat += modifier
		stat = max(0, stat)
	else:
		stat += modifier
