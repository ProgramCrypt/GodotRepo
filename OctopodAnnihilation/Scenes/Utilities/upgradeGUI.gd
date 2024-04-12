extends Control

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var sceneManager = get_node("/root/SceneManager")

var weapon1Upgrades
var weapon2Upgrades
var armorUpgrades

func _ready():
	if playerStats.weapon1["weaponType"] == "projectile":
		if playerStats.weapon1["damageType"] == 0:
			$window/weapon1.text = "Ballistic Gun"
		if playerStats.weapon1["damageType"] == 1:
			$window/weapon1.text = "Laser Gun"
		if playerStats.weapon1["damageType"] == 2:
			$window/weapon1.text = "Plasma Gun"
	elif playerStats.weapon1["weaponType"] == "melee":
		if playerStats.weapon1["damageType"] == 0:
			$window/weapon1.text = "Ballistic Gun"
		if playerStats.weapon1["damageType"] == 1:
			$window/weapon1.text = "Laser Gun"
	
	if playerStats.weapon2["weaponType"] == "projectile":
		if playerStats.weapon2["damageType"] == 0:
			$window/weapon2.text = "Ballistic Gun"
		if playerStats.weapon2["damageType"] == 1:
			$window/weapon2.text = "Laser Gun"
		if playerStats.weapon2["damageType"] == 2:
			$window/weapon2.text = "Plasma Gun"
	elif playerStats.weapon2["weaponType"] == "melee":
		if playerStats.weapon2["damageType"] == 0:
			$window/weapon2.text = "Voltaic Hammer"
		if playerStats.weapon2["damageType"] == 1:
			$window/weapon2.text = "Plasma Shield"
	
	weapon1Upgrades = $weaponUpgrades.pickUpgrades(playerStats.weapon1["weaponType"], playerStats.weapon1["damageType"], playerStats.appliedWeapon1Upgrades)
	weapon2Upgrades = $weaponUpgrades.pickUpgrades(playerStats.weapon2["weaponType"], playerStats.weapon2["damageType"], playerStats.appliedWeapon2Upgrades)
	armorUpgrades = $armorUpgrades.pickUpgrades(playerStats.appliedArmorUpgrades)
	
	setWeapon1Upgrades(weapon1Upgrades)
	setWeapon2Upgrades(weapon2Upgrades)
	setPlayerUpgrades(armorUpgrades)
	

#upgradeList = list of upgrade names. Upgrades should all be applicable to the player's weapons
func setWeapon1Upgrades(upgradeList):
	if len(upgradeList) > 0:
		if upgradeList[0] not in playerStats.appliedWeapon1Upgrades:
			$window/weapon1Upgrade1/Label.text = upgradeList[0]["name"][0]
			$window/weapon1Upgrade1/Description.text = "  " + upgradeList[0]["description"]
			$window/weapon1Upgrade1/Cost.text = "Scrap: " + str(upgradeList[0]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedWeapon1Upgrades.find(upgradeList[0])
			var level = playerStats.appliedWeapon1Upgrades[0][index-1]
			$window/weapon1Upgrade1/Label.text = upgradeList[0]["name"][level]
			$window/weapon1Upgrade1/Description.text = "  " + upgradeList[0]["description"]
			$window/weapon1Upgrade1/Cost.text = "Scrap: " + str(upgradeList[0]["cost"][level]) + "  "
	else:
		$window/weapon1Upgrade1.disabled = true
		$window/weapon1Upgrade1.visible = false
	
	if len(upgradeList) > 1:
		if upgradeList[1] not in playerStats.appliedWeapon1Upgrades:
			$window/weapon1Upgrade2/Label.text = upgradeList[1]["name"][0]
			$window/weapon1Upgrade2/Description.text = "  " + upgradeList[1]["description"]
			$window/weapon1Upgrade2/Cost.text = "Scrap: " + str(upgradeList[1]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedWeapon1Upgrades.find(upgradeList[1])
			var level = playerStats.appliedWeapon1Upgrades[0][index-1]
			$window/weapon1Upgrade2/Label.text = upgradeList[1]["name"][level]
			$window/weapon1Upgrade2/Description.text = "  " + upgradeList[1]["description"]
			$window/weapon1Upgrade2/Cost.text = "Scrap: " + str(upgradeList[1]["cost"][level]) + "  "
	else:
		$window/weapon1Upgrade2.disabled = true
		$window/weapon1Upgrade2.visible = false
	
	if len(upgradeList) > 2:
		if upgradeList[2] not in playerStats.appliedWeapon1Upgrades:
			$window/weapon1Upgrade3/Label.text = upgradeList[2]["name"][0]
			$window/weapon1Upgrade3/Description.text = "  " + upgradeList[2]["description"]
			$window/weapon1Upgrade3/Cost.text = "Scrap: " + str(upgradeList[2]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedWeapon1Upgrades.find(upgradeList[2])
			var level = playerStats.appliedWeapon1Upgrades[0][index-1]
			$window/weapon1Upgrade3/Label.text = upgradeList[2]["name"][level]
			$window/weapon1Upgrade3/Description.text = "  " + upgradeList[2]["description"]
			$window/weapon1Upgrade3/Cost.text = "Scrap: " + str(upgradeList[2]["cost"][level]) + "  "
	else:
		$window/weapon1Upgrade3.disabled = true
		$window/weapon1Upgrade3.visible = false


#upgradeList = list of upgrade names. Upgrades should all be applicable to the player's weapons
func setWeapon2Upgrades(upgradeList):
	if len(upgradeList) > 0:
		if upgradeList[0] not in playerStats.appliedWeapon2Upgrades:
			$window/weapon2Upgrade1/Label.text = upgradeList[0]["name"][0]
			$window/weapon2Upgrade1/Description.text = "  " + upgradeList[0]["description"]
			$window/weapon2Upgrade1/Cost.text = "Scrap: " + str(upgradeList[0]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedWeapon2Upgrades.find(upgradeList[0])
			var level = playerStats.appliedWeapon2Upgrades[0][index-1]
			$window/weapon2Upgrade1/Label.text = upgradeList[0]["name"][level]
			$window/weapon2Upgrade1/Description.text = "  " + upgradeList[0]["description"]
			$window/weapon2Upgrade1/Cost.text = "Scrap: " + str(upgradeList[0]["cost"][level]) + "  "
	else:
		$window/weapon2Upgrade1.disabled = true
		$window/weapon2Upgrade1.visible = false
	
	if len(upgradeList) > 1:
		if upgradeList[1] not in playerStats.appliedWeapon2Upgrades:
			$window/weapon2Upgrade2/Label.text = upgradeList[1]["name"][0]
			$window/weapon2Upgrade2/Description.text = "  " + upgradeList[1]["description"]
			$window/weapon2Upgrade2/Cost.text = "Scrap: " + str(upgradeList[1]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedWeapon2Upgrades.find(upgradeList[1])
			var level = playerStats.appliedWeapon2Upgrades[0][index-1]
			$window/weapon2Upgrade2/Label.text = upgradeList[1]["name"][level]
			$window/weapon2Upgrade2/Description.text = "  " + upgradeList[1]["description"]
			$window/weapon2Upgrade2/Cost.text = "Scrap: " + str(upgradeList[1]["cost"][level]) + "  "
	else:
		$window/weapon2Upgrade2.disabled = true
		$window/weapon2Upgrade2.visible = false
	
	if len(upgradeList) > 2:
		if upgradeList[2] not in playerStats.appliedWeapon2Upgrades:
			$window/weapon2Upgrade3/Label.text = upgradeList[2]["name"][0]
			$window/weapon2Upgrade3/Description.text = "  " + upgradeList[2]["description"]
			$window/weapon2Upgrade3/Cost.text = "Scrap: " + str(upgradeList[2]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedWeapon2Upgrades.find(upgradeList[2])
			var level = playerStats.appliedWeapon2Upgrades[0][index-1]
			$window/weapon2Upgrade3/Label.text = upgradeList[2]["name"][level]
			$window/weapon2Upgrade3/Description.text = "  " + upgradeList[2]["description"]
			$window/weapon2Upgrade3/Cost.text = "Scrap: " + str(upgradeList[2]["cost"][level]) + "  "
	else:
		$window/weapon2Upgrade3.disabled = true
		$window/weapon2Upgrade3.visible = false

#upgradeList = list of upgrade names
func setPlayerUpgrades(upgradeList):
	if len(upgradeList) > 0:
		if upgradeList[0] not in playerStats.appliedArmorUpgrades:
			$window/playerUpgrade1/Label.text = upgradeList[0]["name"][0]
			$window/playerUpgrade1/Description.text = "  " + upgradeList[0]["description"]
			$window/playerUpgrade1/Cost.text = "Scrap: " + str(upgradeList[0]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedArmorUpgrades.find(upgradeList[0])
			var level = playerStats.appliedArmorUpgrades[0][index-1]
			$window/playerUpgrade1/Label.text = upgradeList[0]["name"][level]
			$window/playerUpgrade1/Description.text = "  " + upgradeList[0]["description"]
			$window/playerUpgrade1/Cost.text = "Scrap: " + str(upgradeList[0]["cost"][level]) + "  "
	else:
		$window/playerUpgrade1.disabled = true
		$window/playerUpgrade1.visible = false
	
	if len(upgradeList) > 1:
		if upgradeList[1] not in playerStats.appliedArmorUpgrades:
			$window/playerUpgrade2/Label.text = upgradeList[1]["name"][0]
			$window/playerUpgrade2/Description.text = "  " + upgradeList[1]["description"]
			$window/playerUpgrade2/Cost.text = "Scrap: " + str(upgradeList[1]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedArmorUpgrades.find(upgradeList[1])
			var level = playerStats.appliedArmorUpgrades[0][index-1]
			$window/playerUpgrade2/Label.text = upgradeList[1]["name"][level]
			$window/playerUpgrade2/Description.text = "  " + upgradeList[1]["description"]
			$window/playerUpgrade2/Cost.text = "Scrap: " + str(upgradeList[1]["cost"][level]) + "  "
	else:
		$window/playerUpgrade2.disabled = true
		$window/playerUpgrade2.visible = false
	
	if len(upgradeList) > 2:
		if upgradeList[2] not in playerStats.appliedArmorUpgrades:
			$window/playerUpgrade3/Label.text = upgradeList[2]["name"][0]
			$window/playerUpgrade3/Description.text = "  " + upgradeList[2]["description"]
			$window/playerUpgrade3/Cost.text = "Scrap: " + str(upgradeList[2]["cost"][0]) + "  "
		else:
			var index = playerStats.appliedArmorUpgrades.find(upgradeList[2])
			var level = playerStats.appliedArmorUpgrades[0][index-1]
			$window/playerUpgrade3/Label.text = upgradeList[2]["name"][level]
			$window/playerUpgrade3/Description.text = "  " + upgradeList[2]["description"]
			$window/playerUpgrade3/Cost.text = "Scrap: " + str(upgradeList[2]["cost"][level]) + "  "
	else:
		$window/playerUpgrade3.disabled = true
		$window/playerUpgrade3.visible = false


func _on_continue_pressed():
	if (playerStats.maxHealth-playerStats.currentHealth) > 0:
		playerStats.heal(2)
	if get_tree().get_nodes_in_group('player')[0].isActiveActive == true:
		playerStats.manualActiveAbilityTimeout()
	sceneManager.restartScene()


func _on_weapon_1_upgrade_1_pressed():
	if weapon1Upgrades[0] not in playerStats.appliedWeapon1Upgrades:
		if playerStats.currentScrap >= weapon1Upgrades[0]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-weapon1Upgrades[0]["cost"][0]))
			playerStats.modifyWeapon("weapon1", weapon1Upgrades[0]["stat"], weapon1Upgrades[0]["modifier"][0])
			playerStats.appliedWeapon1Upgrades[0].append(1)
			playerStats.appliedWeapon1Upgrades.append(weapon1Upgrades[0])
			#increaseEnergyUse("weapon1", 1)
			$window/weapon1Upgrade1.disabled = true
			$window/weapon1Upgrade1.visible = false
			$window/weapon1Upgrade2.disabled = true
			$window/weapon1Upgrade2.visible = false
			$window/weapon1Upgrade3.disabled = true
			$window/weapon1Upgrade3.visible = false
	else:
		var index = playerStats.appliedWeapon1Upgrades.find(weapon1Upgrades[0]) - 1
		var level = playerStats.appliedWeapon1Upgrades[0][index]
		if playerStats.currentScrap >= weapon1Upgrades[0]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-weapon1Upgrades[0]["cost"][level]))
			playerStats.modifyWeapon("weapon1", weapon1Upgrades[0]["stat"], weapon1Upgrades[0]["modifier"][level])
			playerStats.appliedWeapon1Upgrades[0][index] += 1
			#increaseEnergyUse("weapon1", 1)
			$window/weapon1Upgrade1.disabled = true
			$window/weapon1Upgrade1.visible = false
			$window/weapon1Upgrade2.disabled = true
			$window/weapon1Upgrade2.visible = false
			$window/weapon1Upgrade3.disabled = true
			$window/weapon1Upgrade3.visible = false


func _on_weapon_1_upgrade_2_pressed():
	if weapon1Upgrades[1] not in playerStats.appliedWeapon1Upgrades:
		if playerStats.currentScrap >= weapon1Upgrades[1]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-weapon1Upgrades[1]["cost"][0]))
			playerStats.modifyWeapon("weapon1", weapon1Upgrades[1]["stat"], weapon1Upgrades[1]["modifier"][0])
			playerStats.appliedWeapon1Upgrades[0].append(1)
			playerStats.appliedWeapon1Upgrades.append(weapon1Upgrades[1])
			#increaseEnergyUse("weapon1", 1)
			$window/weapon1Upgrade1.disabled = true
			$window/weapon1Upgrade1.visible = false
			$window/weapon1Upgrade2.disabled = true
			$window/weapon1Upgrade2.visible = false
			$window/weapon1Upgrade3.disabled = true
			$window/weapon1Upgrade3.visible = false
	else:
		var index = playerStats.appliedWeapon1Upgrades.find(weapon1Upgrades[1]) - 1
		var level = playerStats.appliedWeapon1Upgrades[0][index]
		if playerStats.currentScrap >= weapon1Upgrades[1]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-weapon1Upgrades[1]["cost"][level]))
			playerStats.modifyWeapon("weapon1", weapon1Upgrades[1]["stat"], weapon1Upgrades[1]["modifier"][level])
			playerStats.appliedWeapon1Upgrades[0][index] += 1
			#increaseEnergyUse("weapon1", 1)
			$window/weapon1Upgrade1.disabled = true
			$window/weapon1Upgrade1.visible = false
			$window/weapon1Upgrade2.disabled = true
			$window/weapon1Upgrade2.visible = false
			$window/weapon1Upgrade3.disabled = true
			$window/weapon1Upgrade3.visible = false


func _on_weapon_1_upgrade_3_pressed():
	if weapon1Upgrades[2] not in playerStats.appliedWeapon1Upgrades:
		if playerStats.currentScrap >= weapon1Upgrades[2]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-weapon1Upgrades[2]["cost"][0]))
			playerStats.modifyWeapon("weapon1", weapon1Upgrades[2]["stat"], weapon1Upgrades[2]["modifier"][0])
			playerStats.appliedWeapon1Upgrades[0].append(1)
			playerStats.appliedWeapon1Upgrades.append(weapon1Upgrades[2])
			#increaseEnergyUse("weapon1", 1)
			$window/weapon1Upgrade1.disabled = true
			$window/weapon1Upgrade1.visible = false
			$window/weapon1Upgrade2.disabled = true
			$window/weapon1Upgrade2.visible = false
			$window/weapon1Upgrade3.disabled = true
			$window/weapon1Upgrade3.visible = false
	else:
		var index = playerStats.appliedWeapon1Upgrades.find(weapon1Upgrades[2]) - 1
		var level = playerStats.appliedWeapon1Upgrades[0][index]
		if playerStats.currentScrap >= weapon1Upgrades[2]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-weapon1Upgrades[2]["cost"][level]))
			playerStats.modifyWeapon("weapon1", weapon1Upgrades[2]["stat"], weapon1Upgrades[2]["modifier"][level])
			playerStats.appliedWeapon1Upgrades[0][index] += 1
			#increaseEnergyUse("weapon1", 1)
			$window/weapon1Upgrade1.disabled = true
			$window/weapon1Upgrade1.visible = false
			$window/weapon1Upgrade2.disabled = true
			$window/weapon1Upgrade2.visible = false
			$window/weapon1Upgrade3.disabled = true
			$window/weapon1Upgrade3.visible = false


func _on_weapon_2_upgrade_1_pressed():
	if weapon2Upgrades[0] not in playerStats.appliedWeapon2Upgrades:
		if playerStats.currentScrap >= weapon2Upgrades[0]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-weapon2Upgrades[0]["cost"][0]))
			playerStats.modifyWeapon("weapon2", weapon2Upgrades[0]["stat"], weapon2Upgrades[0]["modifier"][0])
			playerStats.appliedWeapon2Upgrades[0].append(1)
			playerStats.appliedWeapon2Upgrades.append(weapon2Upgrades[0])
			#increaseEnergyUse("weapon2", 1)
			$window/weapon2Upgrade1.disabled = true
			$window/weapon2Upgrade1.visible = false
			$window/weapon2Upgrade2.disabled = true
			$window/weapon2Upgrade2.visible = false
			$window/weapon2Upgrade3.disabled = true
			$window/weapon2Upgrade3.visible = false
	else:
		var index = playerStats.appliedWeapon2Upgrades.find(weapon2Upgrades[0]) - 1
		var level = playerStats.appliedWeapon2Upgrades[0][index]
		if playerStats.currentScrap >= weapon2Upgrades[0]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-weapon2Upgrades[0]["cost"][level]))
			playerStats.modifyWeapon("weapon2", weapon2Upgrades[0]["stat"], weapon2Upgrades[0]["modifier"][level])
			playerStats.appliedWeapon2Upgrades[0][index] += 1
			#increaseEnergyUse("weapon2", 1)
			$window/weapon2Upgrade1.disabled = true
			$window/weapon2Upgrade1.visible = false
			$window/weapon2Upgrade2.disabled = true
			$window/weapon2Upgrade2.visible = false
			$window/weapon2Upgrade3.disabled = true
			$window/weapon2Upgrade3.visible = false


func _on_weapon_2_upgrade_2_pressed():
	if weapon2Upgrades[1] not in playerStats.appliedWeapon2Upgrades:
		if playerStats.currentScrap >= weapon2Upgrades[1]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-weapon2Upgrades[1]["cost"][0]))
			playerStats.modifyWeapon("weapon2", weapon2Upgrades[1]["stat"], weapon2Upgrades[1]["modifier"][0])
			playerStats.appliedWeapon2Upgrades[0].append(1)
			playerStats.appliedWeapon2Upgrades.append(weapon2Upgrades[1])
			#increaseEnergyUse("weapon2", 1)
			$window/weapon2Upgrade1.disabled = true
			$window/weapon2Upgrade1.visible = false
			$window/weapon2Upgrade2.disabled = true
			$window/weapon2Upgrade2.visible = false
			$window/weapon2Upgrade3.disabled = true
			$window/weapon2Upgrade3.visible = false
	else:
		var index = playerStats.appliedWeapon2Upgrades.find(weapon2Upgrades[1]) - 1
		var level = playerStats.appliedWeapon2Upgrades[0][index]
		if playerStats.currentScrap >= weapon2Upgrades[1]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-weapon2Upgrades[1]["cost"][level]))
			playerStats.modifyWeapon("weapon2", weapon2Upgrades[1]["stat"], weapon2Upgrades[1]["modifier"][level])
			playerStats.appliedWeapon2Upgrades[0][index] += 1
			#increaseEnergyUse("weapon2", 1)
			$window/weapon2Upgrade1.disabled = true
			$window/weapon2Upgrade1.visible = false
			$window/weapon2Upgrade2.disabled = true
			$window/weapon2Upgrade2.visible = false
			$window/weapon2Upgrade3.disabled = true
			$window/weapon2Upgrade3.visible = false


func _on_weapon_2_upgrade_3_pressed():
	if weapon2Upgrades[2] not in playerStats.appliedWeapon2Upgrades:
		if playerStats.currentScrap >= weapon2Upgrades[2]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-weapon2Upgrades[2]["cost"][0]))
			playerStats.modifyWeapon("weapon2", weapon2Upgrades[2]["stat"], weapon2Upgrades[2]["modifier"][0])
			playerStats.appliedWeapon2Upgrades[0].append(1)
			playerStats.appliedWeapon2Upgrades.append(weapon2Upgrades[2])
			#increaseEnergyUse("weapon2", 1)
			$window/weapon2Upgrade1.disabled = true
			$window/weapon2Upgrade1.visible = false
			$window/weapon2Upgrade2.disabled = true
			$window/weapon2Upgrade2.visible = false
			$window/weapon2Upgrade3.disabled = true
			$window/weapon2Upgrade3.visible = false
	else:
		var index = playerStats.appliedWeapon2Upgrades.find(weapon2Upgrades[2]) - 1
		var level = playerStats.appliedWeapon2Upgrades[0][index]
		if playerStats.currentScrap >= weapon2Upgrades[2]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-weapon2Upgrades[2]["cost"][level]))
			playerStats.modifyWeapon("weapon2", weapon2Upgrades[2]["stat"], weapon2Upgrades[2]["modifier"][level])
			playerStats.appliedWeapon2Upgrades[0][index] += 1
			#increaseEnergyUse("weapon2", 1)
			$window/weapon2Upgrade1.disabled = true
			$window/weapon2Upgrade1.visible = false
			$window/weapon2Upgrade2.disabled = true
			$window/weapon2Upgrade2.visible = false
			$window/weapon2Upgrade3.disabled = true
			$window/weapon2Upgrade3.visible = false


func _on_player_upgrade_1_pressed():
	if armorUpgrades[0] not in playerStats.appliedArmorUpgrades:
		if playerStats.currentScrap >= armorUpgrades[0]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-armorUpgrades[0]["cost"][0]))
			playerStats.modifyStatValue(armorUpgrades[0]["stat"], armorUpgrades[0]["modifier"][0])
			playerStats.appliedArmorUpgrades[0].append(1)
			playerStats.appliedArmorUpgrades.append(armorUpgrades[0])
			$window/playerUpgrade1.disabled = true
			$window/playerUpgrade1.visible = false
			$window/playerUpgrade2.disabled = true
			$window/playerUpgrade2.visible = false
			$window/playerUpgrade3.disabled = true
			$window/playerUpgrade3.visible = false
	else:
		var index = playerStats.appliedArmorUpgrades.find(armorUpgrades[0]) - 1
		var level = playerStats.appliedArmorUpgrades[0][index]
		if playerStats.currentScrap >= armorUpgrades[0]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-armorUpgrades[0]["cost"][level]))
			playerStats.modifyStatValue(armorUpgrades[0]["stat"], armorUpgrades[0]["modifier"][level])
			playerStats.appliedArmorUpgrades[0][index] += 1
			$window/playerUpgrade1.disabled = true
			$window/playerUpgrade1.visible = false
			$window/playerUpgrade2.disabled = true
			$window/playerUpgrade2.visible = false
			$window/playerUpgrade3.disabled = true
			$window/playerUpgrade3.visible = false


func _on_player_upgrade_2_pressed():
	if armorUpgrades[1] not in playerStats.appliedArmorUpgrades:
		if playerStats.currentScrap >= armorUpgrades[1]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-armorUpgrades[1]["cost"][0]))
			playerStats.modifyStatValue(armorUpgrades[1]["stat"], armorUpgrades[1]["modifier"][0])
			playerStats.appliedArmorUpgrades[0].append(1)
			playerStats.appliedArmorUpgrades.append(armorUpgrades[1])
			$window/playerUpgrade1.disabled = true
			$window/playerUpgrade1.visible = false
			$window/playerUpgrade2.disabled = true
			$window/playerUpgrade2.visible = false
			$window/playerUpgrade3.disabled = true
			$window/playerUpgrade3.visible = false
	else:
		var index = playerStats.appliedArmorUpgrades.find(armorUpgrades[1]) - 1
		var level = playerStats.appliedArmorUpgrades[0][index]
		if playerStats.currentScrap >= armorUpgrades[1]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-armorUpgrades[1]["cost"][level]))
			playerStats.modifyStatValue(armorUpgrades[1]["stat"], armorUpgrades[1]["modifier"][level])
			playerStats.appliedArmorUpgrades[0][index] += 1
			$window/playerUpgrade1.disabled = true
			$window/playerUpgrade1.visible = false
			$window/playerUpgrade2.disabled = true
			$window/playerUpgrade2.visible = false
			$window/playerUpgrade3.disabled = true
			$window/playerUpgrade3.visible = false


func _on_player_upgrade_3_pressed():
	if armorUpgrades[2] not in playerStats.appliedArmorUpgrades:
		if playerStats.currentScrap >= armorUpgrades[2]["cost"][0]:
			playerStats.modifyStatValue("currentScrap", (0-armorUpgrades[2]["cost"][0]))
			playerStats.modifyStatValue(armorUpgrades[2]["stat"], armorUpgrades[2]["modifier"][0])
			playerStats.appliedArmorUpgrades[0].append(1)
			playerStats.appliedArmorUpgrades.append(armorUpgrades[2])
			$window/playerUpgrade1.disabled = true
			$window/playerUpgrade1.visible = false
			$window/playerUpgrade2.disabled = true
			$window/playerUpgrade2.visible = false
			$window/playerUpgrade3.disabled = true
			$window/playerUpgrade3.visible = false
	else:
		var index = playerStats.appliedArmorUpgrades.find(armorUpgrades[2]) - 1
		var level = playerStats.appliedArmorUpgrades[0][index]
		if playerStats.currentScrap >= armorUpgrades[2]["cost"][level]:
			playerStats.modifyStatValue("currentScrap", (0-armorUpgrades[2]["cost"][level]))
			playerStats.modifyStatValue(armorUpgrades[2]["stat"], armorUpgrades[2]["modifier"][level])
			playerStats.appliedArmorUpgrades[0][index] += 1
			$window/playerUpgrade1.disabled = true
			$window/playerUpgrade1.visible = false
			$window/playerUpgrade2.disabled = true
			$window/playerUpgrade2.visible = false
			$window/playerUpgrade3.disabled = true
			$window/playerUpgrade3.visible = false


func increaseEnergyUse(weapon, energy):
	playerStats.modifyWeapon(weapon, "energyUse", energy)
