extends CharacterBody2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var speed: int
@onready var animations = $AnimationPlayer
@export var ballisticProjectile: PackedScene
@export var laserProjectile: PackedScene
@export var plasmaProjectile: PackedScene
var hasWeapon = true
var laserActive = false
var direction = "Down"

@onready var baseBallisticDamage = StatModification.baseBallisticDamage
@onready var baseLaserDamage = StatModification.baseLaserDamage
@onready var basePlasmaDamage = StatModification.basePlasmaDamage
var damageMultiplier = 1

var activeWeapon = "weapon1"


func _ready():
	speed = playerStats.speed * 8


func handleInput(_delta):
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
		if playerStats.currentEnergy != 0:
			shoot()
	
	if Input.is_action_just_released("attack"):
		if laserActive == true: 
			$Arm/Muzzle/laserProjectile.queue_free()
			laserActive = false
	
	if Input.is_action_just_released("scroll"):
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
		projectile.setShooter(get_groups(),{"baseDamage": baseBallisticDamage, "damageMultiplier": damageMultiplier, "projectileRange": $Arm.projectileRange, "speed": $Arm.speed, "penetration": $Arm.penetration, "projectileMultiplier": $Arm.projectilesPerShot, "effectsOnHit": $Arm.effectsOnHit})
	if $Arm.damageType == 1:
		var projectile = laserProjectile.instantiate()
		$Arm/Muzzle.add_child(projectile)
		projectile.setShooter(get_groups(),{"baseDamage": baseLaserDamage, "damageMultiplier": damageMultiplier, "projectileRange": $Arm.projectileRange, "speed": $Arm.speed, "penetration": $Arm.penetration, "projectileMultiplier": $Arm.projectilesPerShot, "effectsOnHit": $Arm.effectsOnHit})
		laserActive = true
	if $Arm.damageType == 2:
		playerStats.useEnergy($Arm.energyUse)
		var projectile = plasmaProjectile.instantiate()
		owner.add_child(projectile)
		projectile.transform = $Arm/Muzzle.global_transform
		projectile.setShooter(get_groups(),{"baseDamage": basePlasmaDamage, "damageMultiplier": damageMultiplier, "projectileRange": $Arm.projectileRange, "speed": $Arm.speed, "penetration": $Arm.penetration, "projectileMultiplier": $Arm.projectilesPerShot, "effectsOnHit": $Arm.effectsOnHit})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handleInput(delta)
	move_and_slide()
	updateAnimation()
	
	if laserActive == true:
		playerStats.useEnergy($Arm.energyUse * delta)


