extends Node

var baseBallisticDamage = 3
var baseLaserDamage = 0.1
var basePlasmaDamage = 5


func ballisticDamage(baseDamage = baseBallisticDamage, ballisticResistance = 0):
	var damage = baseDamage * (1-(ballisticResistance/100))
	return damage


func laserDamage(timer, baseDamage = baseLaserDamage, laserResistance = 0):
	var damage = baseDamage * (1-(laserResistance/100)) * timer**2
	return damage


func plasmaDamage(baseDamage = basePlasmaDamage, plasmaResistance = 0):
	var damage = baseDamage * (1-(plasmaResistance/100))
	return damage


func heal(value, modifier):
	var healAmount = value
	return healAmount


func modifyStatValue(stat, modifier):
	var newStat = stat
	if stat in ["speed", "strength", "rateOfFire", "gunAccuracy"]:
		newStat += modifier
		newStat = max(0, newStat)
	elif stat in ["ballisticResistance", "laserResistance", "plasmaResistance", "fireResistance", "explosionResistance", "slowResistance", "stunResistance"]:
		newStat += modifier
		newStat = min(100, newStat)
	else:
		newStat += modifier
	return newStat
