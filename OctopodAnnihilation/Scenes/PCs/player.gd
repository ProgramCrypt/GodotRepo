extends CharacterBody2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var speed: int
@onready var animations = $AnimationPlayer
@export var ballisticProjectile: PackedScene
@export var laserProjectile: PackedScene
@export var plasmaProjectile: PackedScene
@export var meleeSwing: PackedScene
var hasWeapon = true
var laserActive = false
var direction = "Down"
var activeWeapon = "weapon1"
var attackTimer = 0
var isSwinging = false
var totalSwingDistance = 0

@onready var baseBallisticDamage = StatModification.baseBallisticDamage
@onready var baseLaserDamage = StatModification.baseLaserDamage
@onready var basePlasmaDamage = StatModification.basePlasmaDamage


func _ready():
	speed = playerStats.speed * 8
	$laserChargeTimer.one_shot = true


func handleInput(_delta):
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
		if playerStats.currentEnergy != 0:
			if $Arm.weaponType == "projectile":
				if $Arm.damageType == 1:
					$laserChargeTimer.start($Arm.fireRate)
				else:
					if attackTimer <= 0:
						shoot()
						attackTimer = $Arm.fireRate
			if $Arm.weaponType == "melee":
				if attackTimer <= 0:
					swing()
					attackTimer = $Arm.swingRate
	
	if Input.is_action_just_released("attack"):
		if $laserChargeTimer.time_left > 0:
			$laserChargeTimer.stop()
		if laserActive == true: 
			for child in $Arm/Muzzle.get_children():
				if child.is_in_group("laserProjectile"):
					child.queue_free()
			laserActive = false
	
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
		projectile.setShooter(get_groups(),{"damage": $Arm.damage, "projectileRange": $Arm.projectileRange, "projectileSpeed": $Arm.projectileSpeed, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})
	if $Arm.damageType == 1:
		for i in range(int($Arm.projectileSize)):
			var projectile = laserProjectile.instantiate()
			$Arm/Muzzle.add_child(projectile)
			var offset = (int($Arm.projectileSize)/2) - 0.5
			projectile.position.y += (i - offset) * 2
			projectile.setShooter(get_groups(),{"damage": $Arm.damage, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})
		laserActive = true
	if $Arm.damageType == 2:
		playerStats.useEnergy($Arm.energyUse)
		var projectile = plasmaProjectile.instantiate()
		owner.add_child(projectile)
		projectile.transform = $Arm/Muzzle.global_transform
		var fireAngle = randf_range(-$Arm.accuracy/2, $Arm.accuracy/2)
		projectile.rotation_degrees += fireAngle
		projectile.setShooter(get_groups(),{"damage": $Arm.damage, "projectileRange": $Arm.projectileRange, "projectileSpeed": $Arm.projectileSpeed, "projectileSize": $Arm.projectileSize, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})


func swing():
	isSwinging = true
	playerStats.useEnergy($Arm.energyUse)
	var swing = meleeSwing.instantiate()
	add_child(swing)
	swing.position = Vector2(0, 6)
	swing.setProperties(get_groups(), {"damage": $Arm.damage, "swingRange": $Arm.swingRange, "swingDirection": (rotation+get_angle_to(get_global_mouse_position())), "swingAngle": $Arm.swingAngle, "swingSpeed": $Arm.swingSpeed, "effectsOnHit": $Arm.effectsOnHit})	


# Called every frame. 'delta' is the elapsed time since the previous frame.
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


func _on_laser_charge_timer_timeout():
	if $Arm.damageType == 1:
		shoot()
