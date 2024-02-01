extends Node

var baseBallisticDamage = 3
var baseLaserDamage = 0.1
var basePlasmaDamage = 5

func ballisticDamage(baseDamage = baseBallisticDamage, damageModifier = 0, ballisticResistance = 0):
	var damage = (baseDamage + damageModifier) * (1-(ballisticResistance/100))
	return damage

func laserDamage(timer, baseDamage = baseLaserDamage, damageModifier = 0, laserResistance = 0):
	var damage = (baseDamage + damageModifier) * (1-(laserResistance/100)) * timer**2
	return damage

func plasmaDamage(baseDamage = basePlasmaDamage, damageModifier = 0, plasmaResistance = 0):
	var damage = (baseDamage + damageModifier) * (1-(plasmaResistance/100))
	return damage

func heal(value, modifier):
	var healAmount = value
	return healAmount

func modifyStatValue(stat, modifier):
	if stat in ["speed", "strength", "rateOfFire", "gunAccuracy"]:
		stat += modifier
		stat = max(0, stat)
	elif stat in ["ballisticResistance", "laserResistance", "plasmaResistance", "fireResistance", "explosionResistance", "slowResistance", "stunResistance"]:
		stat += modifier
		stat = min(100, stat)
	else:
		stat += modifier
	return stat
