extends Node2D

@export var maxHealth : float
@export var maxEnergy : float
@export var speed : float
@export var strength : float
@export var rateOfFire : float
@export var gunAccuracy : float
@export var ballisticResistance : float
@export var laserResistance : float
@export var plasmaResistance : float
@export var bleedingResistance : float
@export var fireResistance : float
@export var explosionResistance : float
@export var slowResistance : float
@export var stunResistance : float
@export var effectsOnHit : Array


#PlayerUpgrades = [{"levels": int, "name": [upgradeName1, upgradeName2, ...], "stat": stat, "modifier": [mod1, mod2, ...], "cost": [cost1, cost2, ...], "description": ""}]
#{"levels": null, "name": [], "stat": "", "modifier": [], "cost": [], "description": ""}

var armorUpgrades = [
	{"levels": 3, "name": ["Onboard Medical\nUnit Mk. I", "Onboard Medical\nUnit Mk. II", "Onboard Medical\nUnit Mk. III"], "stat": "maxHealth", "modifier": [5, 5, 5], "cost": [40, 55, 70], "description": "Increased Max Health"},
	{"levels": 3, "name": ["Li-Ion Batteries", "Li-Sulfur Batteries", "Radioisotope Thermoelectric\nGenerator"], "stat": "maxEnergy", "modifier": [5, 5, 5], "cost": [45, 60, 75], "description": "Increased Max Energy"},
	{"levels": 6, "name": ["Leg Hydraulics\nMk. I", "Leg Hydraulics\nMk. II", "Leg Hydraulics\nMk. III", "Leg Hydraulics\nMk. IV", "Leg Hydraulics\nMk. V", "Leg Hydraulics\nMk. VI"], "stat": "speed", "modifier": [3, 3, 3, 3, 3, 3], "cost": [25, 35, 45, 55, 65, 75], "description": "Increased Speed"},
	#{"levels": 6, "name": ["Arm Hydraulics\nMk. I", "Arm Hydraulics\nMk. II", "Arm Hydraulics\nMk. III", "Arm Hydraulics\nMk. IV", "Arm Hydraulics\nMk. V", "Arm Hydraulics\nMk. VI"], "stat": "strength", "modifier": [3, 3, 3, 3, 3, 3], "cost": [45, 55, 65, 75, 85, 95], "description": "Increased Strength"}
	]
	
	
func pickUpgrades(currentUpgrades):
	var upgradeList = armorUpgrades
	var selectedUpgrades = []
	while len(upgradeList) > 0:
		var val = randi_range(0, (len(upgradeList)-1))
		if upgradeList[val] not in selectedUpgrades:
			if upgradeList[val] not in currentUpgrades:
				selectedUpgrades.append(upgradeList[val])
			else:
				var index = currentUpgrades.find(upgradeList[val]) - 1
				if upgradeList[val]["levels"] > currentUpgrades[0][index]:
					selectedUpgrades.append(upgradeList[val])
				else:
					upgradeList.pop_at(val)
		else:
			upgradeList.pop_at(val)
	
	return selectedUpgrades
