extends CharacterBody2D

signal activeAbilityCooldown()
signal setActiveActive()

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")
@onready var audioManager = get_node("/root/AudioManager")

@export var pauseMenu : PackedScene

@onready var animations = $AnimationPlayer
@export var ballisticProjectile: PackedScene
@export var laserProjectile: PackedScene
@export var plasmaProjectile: PackedScene
@export var meleeSwing: PackedScene
@export var effectArea: PackedScene
var hasWeapon = true
var laserActive = false
var direction = "Down"
var activeWeapon = "weapon1"
var attackTimer = 0
var isSwinging = false
var totalSwingDistance = 0
var isActiveActive = false
var isActiveCooldownActive = false

@onready var baseBallisticDamage = StatModification.baseBallisticDamage
@onready var baseLaserDamage = StatModification.baseLaserDamage
@onready var basePlasmaDamage = StatModification.basePlasmaDamage


func _ready():
	$laserChargeTimer.one_shot = true
	$activeAbilityTimer.one_shot = true
	$activeAbilityCooldownTimer.one_shot = true


func handleInput(_delta):
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	velocity = moveDirection * playerStats.speed * 11
	
	if Input.is_action_just_pressed("attack"):
		if playerStats.currentEnergy != 0:
			if $Arm.weaponType == "projectile":
				if $Arm.damageType == 1:
					$laserChargeTimer.start($Arm.fireRate)
					$"/root/AudioManager/weapons/laser/warmUp".play(0)
				else:
					if attackTimer <= 0:
						shoot()
						if playerStats.playerTypeDict[playerStats.playerType].passiveAbility == "rage":
							attackTimer = max($Arm.fireRate * (playerStats.currentHealth/playerStats.maxHealth), $Arm.fireRate * 0.3)
						else:
							attackTimer = $Arm.fireRate
			if $Arm.weaponType == "melee":
				if attackTimer <= 0:
					swing()
					if playerStats.playerTypeDict[playerStats.playerType].passiveAbility == "rage":
						attackTimer = max($Arm.fireRate * (playerStats.currentHealth/playerStats.maxHealth), $Arm.fireRate * 0.3)
					else:
						attackTimer = $Arm.fireRate
	
	if Input.is_action_just_released("attack"):
		if $laserChargeTimer.time_left > 0:
			$laserChargeTimer.stop()
			$"/root/AudioManager/weapons/laser/warmUp".stop()
		if laserActive == true: 
			for child in $Arm/Muzzle.get_children():
				if child.is_in_group("laserProjectile"):
					child.queue_free()
			laserActive = false
			$"/root/AudioManager/weapons/laser/active".stop()
	
	if Input.is_action_just_pressed("activeAbility"):
		if isActiveActive == false and $activeAbilityCooldownTimer.time_left <= 0:
			useActiveAbility(playerStats.playerTypeDict[playerStats.playerType].activeAbility)
	
	if Input.is_action_just_released("scroll"):
		if laserActive == true:
			$Arm/Muzzle/laserProjectile.queue_free()
			laserActive = false
		
		if activeWeapon == "weapon1":
			$Arm.changeWeapon(playerStats.weapon2)
			activeWeapon = "weapon2"
		elif activeWeapon == "weapon2":
			$Arm.changeWeapon(playerStats.weapon1)
			activeWeapon = "weapon1"
	
	if Input.is_action_just_pressed("escape"):
		var menu = pauseMenu.instantiate()
		get_tree().root.add_child(menu)
		get_tree().paused = true


func updateAnimation():
	if hasWeapon == false:
		get_node("Arm").visible = false
		if velocity.length() == 0:
			animations.play("face" + direction)
		else:
			if velocity.y < 0: direction = "Up"
			elif velocity.y > 0: direction = "Down"
			elif velocity.x < 0: direction = "Left"
			elif velocity.x > 0: direction = "Right"
			
			animations.play("walk" + direction)
	else:
		if isSwinging == false:
			get_node("Arm").visible = true
			get_node("Arm").look_at(get_global_mouse_position())
			get_node("Arm").set_rotation_degrees(get_node("Arm").get_rotation_degrees()+180)
			
			var lookVector = get_global_mouse_position() - position
			lookVector /= sqrt(lookVector.x*lookVector.x + lookVector.y*lookVector.y)
			if lookVector.x >= -0.70 and lookVector.x <= 0.70 and lookVector.y < 0:
				direction = "Up"
				get_node("Arm").position.x = -11
				get_node("Arm").scale.y = 1
				get_node("Arm").set_z_index(-1)
			elif lookVector.x >= -0.70 and lookVector.x <= 0.70 and lookVector.y > 0:
				direction = "Down"
				get_node("Arm").position.x = 11
				get_node("Arm").scale.y = 1
				get_node("Arm").set_z_index(0)
			elif lookVector.x < -0.70:
				direction = "Left"
				get_node("Arm").position.x = 0
				get_node("Arm").scale.y = 1
				get_node("Arm").set_z_index(0)
			elif lookVector.x > 0.70:
				direction = "Right"
				get_node("Arm").position.x = 5
				get_node("Arm").scale.y = -1
				get_node("Arm").set_z_index(-1)
		
		if velocity.length() == 0:
			animations.play("face" + direction + "Armed")
		else:
			animations.play("walk" + direction + "Armed")


func shoot():
	if $Arm.damageType == 0:
		playerStats.useEnergy($Arm.energyUse)
		var projectile = ballisticProjectile.instantiate()
		owner.add_child(projectile)
		projectile.transform = $Arm/Muzzle.global_transform
		var fireAngle = randf_range(-$Arm.accuracy/2, $Arm.accuracy/2)
		projectile.rotation_degrees += fireAngle
		var projVector = Vector2.from_angle(projectile.rotation)
		projVector = -projVector
		var addedSpeed = velocity.dot(projVector)/2
		projectile.setShooter(get_groups(),{"damage": $Arm.damage, "projectileRange": $Arm.projectileRange, "projectileSpeed": $Arm.projectileSpeed + addedSpeed, "parentVelocity": velocity, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})
		audioManager.ballisticFire()
	if $Arm.damageType == 1:
		for i in range(int($Arm.projectileSize)):
			var projectile = laserProjectile.instantiate()
			$Arm/Muzzle.add_child(projectile)
			var offset = (int($Arm.projectileSize)/2) - 0.5
			projectile.position.y += (i - offset) * 2
			projectile.setShooter(get_groups(),{"damage": $Arm.damage, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})
		laserActive = true
		$"/root/AudioManager/weapons/laser/warmUp".stop()
		$"/root/AudioManager/weapons/laser/active".play(0)
	if $Arm.damageType == 2:
		playerStats.useEnergy($Arm.energyUse)
		var projectile = plasmaProjectile.instantiate()
		owner.add_child(projectile)
		projectile.transform = $Arm/Muzzle.global_transform
		var fireAngle = randf_range(-$Arm.accuracy/2, $Arm.accuracy/2)
		projectile.rotation_degrees += fireAngle
		var projVector = Vector2.from_angle(projectile.rotation)
		projVector = -projVector
		var addedSpeed = velocity.dot(projVector)/2
		projectile.setShooter(get_groups(),{"damage": $Arm.damage, "projectileRange": $Arm.projectileRange, "projectileSpeed": $Arm.projectileSpeed + addedSpeed, "parentVelocity": velocity, "projectileSize": $Arm.projectileSize, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})
		$"/root/AudioManager/weapons/plasma/fire1".play(0)
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "cloaking" and isActiveActive == true:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.playerCloaked(false)
		$activeAbilityTimer.start(0.05)


func swing():
	isSwinging = true
	playerStats.useEnergy($Arm.energyUse)
	var swingArea = meleeSwing.instantiate()
	add_child(swingArea)
	swingArea.position = Vector2(0, 6)
	swingArea.setProperties(get_groups(), {"damageType": $Arm.damageType, "damage": $Arm.damage, "swingRange": $Arm.swingRange, "swingDirection": (rotation+get_angle_to(get_global_mouse_position())), "swingAngle": $Arm.swingAngle, "swingSpeed": $Arm.swingSpeed, "effectsOnHit": $Arm.effectsOnHit})
	if $Arm.damageType == 0:
		audioManager.hammerSwing()
		$"/root/AudioManager/weapons/hammer/zap".play(0)
	if $Arm.damageType == 1:
		audioManager.shieldSwing()


func useActiveAbility(activeAbility):
	if activeAbility == "adrenaline":
		playerStats.modifyStatValue("maxHealth", 10)
		playerStats.modifyStatValue("currentHealth", 10)
		playerStats.modifyStatValue("maxEnergy", 10)
		playerStats.modifyStatValue("currentEnergy", 10)
		playerStats.speed += 5
		playerStats.strength += 5
		playerStats.rateOfFire += 10
		playerStats.gunAccuracy += 10
		playerStats.ballisticResistance += 20
		playerStats.laserResistance += 20
		playerStats.plasmaResistance += 20
		playerStats.bleedingResistance += 20
		playerStats.fireResistance += 20
		playerStats.explosionResistance += 20
		playerStats.slowResistance += 50
		playerStats.stunResistance += 50
		
	elif activeAbility == "cloaking":
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.playerCloaked(true)
		modulate.a = 0.5
	
	elif activeAbility == "seismicImpact":
		var stun = effectArea.instantiate()
		add_child(stun)
		stun.setProperties("player", "stun", playerStats.playerTypeDict[playerStats.playerType].activeAbilityLength, 200)
		var bleeding = effectArea.instantiate()
		add_child(bleeding)
		bleeding.setProperties("player", "bleeding", playerStats.playerTypeDict[playerStats.playerType].activeAbilityLength, 200)
	
	elif activeAbility == "dash":
		playerStats.speed += 70
		playerStats.vulnerable = false
	
	elif activeAbility == "decoy":
		pass
	
	elif activeAbility == "mitosis":
		pass
	
	elif activeAbility == "mineLayer":
		pass
	
	isActiveActive = true
	emit_signal("setActiveActive")
	$activeAbilityTimer.start(playerStats.playerTypeDict[playerStats.playerType].activeAbilityLength)


func _physics_process(delta):
	handleInput(delta)
	move_and_slide()
	updateAnimation()
	
	if attackTimer > 0:
		attackTimer -= delta
	
	if laserActive == true:
		playerStats.useEnergy($Arm.energyUse * delta)
	
	if isSwinging == true:
		if direction == "Up":
			$Arm.rotation_degrees += -((90-$Arm.swingAngle/2) + $Arm.swingAngle) * delta / $Arm.swingSpeed
		if direction == "Right":
			$Arm.rotation_degrees += ((90-$Arm.swingAngle/2) + $Arm.swingAngle) * delta / $Arm.swingSpeed
		if direction == "Down":
			$Arm.rotation_degrees += -((90-$Arm.swingAngle/2) + $Arm.swingAngle) * delta / $Arm.swingSpeed
		if direction == "Left":
			$Arm.rotation_degrees += -((90-$Arm.swingAngle/2) + $Arm.swingAngle) * delta / $Arm.swingSpeed
		totalSwingDistance += ((90-$Arm.swingAngle/2) + $Arm.swingAngle) * delta / $Arm.swingSpeed
		if totalSwingDistance >= ((90-$Arm.swingAngle/2) + $Arm.swingAngle):
			totalSwingDistance = 0
			isSwinging = false
	
	if isActiveCooldownActive == true:
		emit_signal("activeAbilityCooldown")


func _on_laser_charge_timer_timeout():
	if $Arm.damageType == 1:
		shoot()


func _on_active_ability_timer_timeout():
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "adrenaline":
		playerStats.modifyStatValue("maxHealth", -10)
		playerStats.modifyStatValue("maxEnergy", -10)
		playerStats.speed -= 5
		playerStats.strength -= 5
		playerStats.rateOfFire -= 10
		playerStats.gunAccuracy -= 10
		playerStats.ballisticResistance -= 20
		playerStats.laserResistance -= 20
		playerStats.plasmaResistance -= 20
		playerStats.bleedingResistance -= 20
		playerStats.fireResistance -= 20
		playerStats.explosionResistance -= 20
		playerStats.slowResistance -= 50
		playerStats.stunResistance -= 50
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "cloaking":
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.playerCloaked(false)
		modulate.a = 1
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "seismicImpact":
		pass
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "dash":
		playerStats.speed -= 70
		playerStats.vulnerable = true
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "decoy":
		pass
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "mitosis":
		pass
	
	if playerStats.playerTypeDict[playerStats.playerType].activeAbility == "mineLayer":
		pass
	
	isActiveActive = false
	emit_signal("setActiveActive")
	$activeAbilityCooldownTimer.start(playerStats.playerTypeDict[playerStats.playerType].activeAbilityCooldown)
	isActiveCooldownActive = true


func _on_active_ability_cooldown_timer_timeout():
	isActiveCooldownActive = true
