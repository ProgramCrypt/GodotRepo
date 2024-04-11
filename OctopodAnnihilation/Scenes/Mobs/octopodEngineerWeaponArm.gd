extends Sprite2D

var damageType : int = 1 #0=hammer, 1=shield
var damage : float = 8 #value of health lost
var swingRange : float = 45
var swingAngle : float = 60
var swingRate : float = 2
var swingSpeed : float = 0.2
var effectsOnHit : Array

func initialize(stats):
	damageType = stats.damageType
	damage = stats.damage
	swingRange = stats.swingRange
	swingAngle = stats.swingAngle
	swingRate = stats.swingRate
	swingSpeed = stats.swingSpeed
	effectsOnHit = stats.effectsOnHit


func modifyStatValue(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "swingRange":
		swingRange += modifier
		swingRange = max(20, swingRange)
	if stat == "swingAngle":
		swingAngle += modifier
		swingAngle = max(20, swingAngle)
	if stat == "swingRate":
		swingRate += modifier
		swingRate = max(0, swingRate)
	if stat == "swingSpeed":
		swingSpeed += modifier
		swingSpeed = max(0, swingSpeed)
	if stat == "effectsOnHit":
		effectsOnHit.append(modifier)
