extends Node

var type : int #0=hammer, 1=shield
var damage : float #value of health lost
var energyUse : float #value of energy used per swing
var swingRange : float #number of pixels outward swing prjects
var swingAngle : float #number of degrees of width of swing
var swingRate : float #time between swings
var swingSpeed : float #time that a swing takes
var effectsOnHit : Array

func initialize(stats : ProjectileWeaponStatList):
	type = stats.type
	damage = stats.damage
	energyUse = stats.energyUse
	swingRange = stats.swingRange
	swingAngle = stats.swingAngle
	swingRate = stats.swingRate
	swingSpeed = stats.swingSpeed
	effectsOnHit = stats.effectsOnHit

func setStatValue(stat, value):
	if stat == "damage":
		damage = value
	if stat == "energyUse":
		energyUse = value
	if stat == "swingRange":
		swingRange = value
	if stat == "swingAngle":
		swingAngle = value
	if stat == "swingRate":
		swingRate = value
	if stat == "swingSpeed":
		swingSpeed = value
	if stat == "effectsOnHit":
		effectsOnHit = value
	

func modifyStatValue(stat, modifier):
	if stat == "damage":
		damage += modifier
		damage = max(0, damage)
	if stat == "energyUse":
		energyUse += modifier
		energyUse = max(0.1, energyUse)
	if stat == "swingRange":
		swingRange += modifier
		swingRange = max(5, swingRange)
	if stat == "swingAngle":
		swingAngle += modifier
		swingAngle = max(1, swingAngle)
	if stat == "swingRate":
		swingRate += modifier
		swingRate = max(0, swingRate)
	if stat == "swingSpeed":
		swingSpeed += modifier
		swingSpeed = max(0.01, swingSpeed)
	if stat == "effectsOnHit":
		effectsOnHit.append(modifier)
