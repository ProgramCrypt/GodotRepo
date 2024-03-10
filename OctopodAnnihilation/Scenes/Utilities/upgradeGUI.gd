extends Control

var weapon1Upgrade1 = ""
var weapon1Upgrade2 = ""
var weapon1Upgrade3 = ""

var weapon2Upgrade1 = ""
var weapon2Upgrade2 = ""
var weapon2Upgrade3 = ""

var playerUpgrade1 = ""
var playerUpgrade2 = ""
var playerUpgrade3 = ""

#upgradeList = list of upgrade names. Upgrades should all be applicable to the player's weapons
func setWeaponUpgrades(upgradeList):
	$window/weaponUpgrade1/Label.text = upgradeList[0]
	$window/weaponUpgrade2/Label.text = upgradeList[1]
	$window/weaponUpgrade3/Label.text = upgradeList[2]


#upgradeList = list of upgrade names
func setPlayerUpgrades(upgradeList):
	$window/playerUpgrade1/Label.text = upgradeList[0]
	$window/playerUpgrade2/Label.text = upgradeList[1]
	$window/playerUpgrade3/Label.text = upgradeList[2]


