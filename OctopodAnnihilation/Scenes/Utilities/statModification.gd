extends Node

var baseBallisticDamage = 3
var baseLaserDamage = 0.2
var basePlasmaDamage = 5

#damageModifiers = {"ballisticResistance": 0, damageMultiplier": 0}
func ballisticDamage(damageModifiers, baseDamage = baseBallisticDamage):
	var damage = (baseDamage * damageModifiers["damageMultiplier"]) * (1-(damageModifiers["ballisticResistance"]/100))
	return damage

#damageModifiers = {"laserResistance": 0, damageModifier": 0}
func laserDamage(damageModifiers, timer, baseDamage = baseLaserDamage):
	var damage = (baseDamage * damageModifiers["damageMultiplier"]) * (1-(damageModifiers["laserResistance"]/100)) * timer**2
	return damage

#damageModifiers = {"plasmaResistance": 0, damageModifier": 0}
func plasmaDamage(damageModifiers, baseDamage = basePlasmaDamage):
	var damage = (baseDamage * damageModifiers["damageMultiplier"]) * (1-(damageModifiers["plasmaResistance"]/100))
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
