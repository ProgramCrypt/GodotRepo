extends Node

var baseBallisticDamage = 3
var baseLaserDamage = 0.1
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
	if stat in ["speed", "strength", "rateOfFire", "gunAccuracy"]:
		stat += modifier
		stat = max(0, stat)
	elif stat in ["ballisticResistance", "laserResistance", "plasmaResistance", "fireResistance", "explosionResistance", "slowResistance", "stunResistance"]:
		stat += modifier
		stat = min(100, stat)
	else:
		stat += modifier
	return stat
