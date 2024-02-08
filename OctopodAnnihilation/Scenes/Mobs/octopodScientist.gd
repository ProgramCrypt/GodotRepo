extends CharacterBody2D

@export var enemyType : Resource

var modifiers = {}

var maxHealth : int
var currentHealth : int
var speed : int
var strength : int
var rateOfFire : int
var gunAccuracy : int
var ballisticResistance : int
var laserResistance : int
var plasmaResistance : int
var bleedingResistance : int
var fireResistance : int
var explosionResistance : int
var slowResistance : int
var stunResistance : int

@export var stopDistance: int = 150
@export var agroDistance: int = 1000

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@onready var animations = $AnimationPlayer
var direction = "Down"

#@export var testProjectile: PackedScene
#var currentTestProjectile
#var testProjectileList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var doShoot = false
var doShootToggle = false
var laser = null
@export var projectile: PackedScene
var timer = 1.0

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

@export var weaponType : Resource

func _ready() -> void:
	nav_agent.target_desired_distance = stopDistance
	
	initialize(enemyType)
	speed = speed * 8
	
	$Arm.initialize(weaponType)

func updateAnimation():
	get_node("Arm").look_at(player.position)
	get_node("Arm").set_rotation_degrees(get_node("Arm").get_rotation_degrees()+180)
	
	var lookVector = player.position - position
	lookVector /= sqrt(lookVector.x*lookVector.x + lookVector.y*lookVector.y)
	if lookVector.x >= -0.70 and lookVector.x <= 0.70 and lookVector.y < 0:
		direction = "Up"
		get_node("Arm").position.x = 0
		get_node("Arm").scale.y = 1
		get_node("Arm").set_z_index(0)
		get_node("Arm").set_rotation_degrees(get_node("Arm").get_rotation_degrees()-3)
	elif lookVector.x >= -0.70 and lookVector.x <= 0.70 and lookVector.y > 0:
		direction = "Down"
		get_node("Arm").position.x = 0
		get_node("Arm").scale.y = -1
		get_node("Arm").set_z_index(0)
		get_node("Arm").set_rotation_degrees(get_node("Arm").get_rotation_degrees()+3)
	elif lookVector.x < -0.70:
		direction = "Left"
		get_node("Arm").position.x = 0
		get_node("Arm").scale.y = 1
		get_node("Arm").set_z_index(0)
		get_node("Arm").set_rotation_degrees(get_node("Arm").get_rotation_degrees()-3)
	elif lookVector.x > 0.70:
		direction = "Right"
		get_node("Arm").position.x = 0
		get_node("Arm").scale.y = -1
		get_node("Arm").set_z_index(0)
		get_node("Arm").set_rotation_degrees(get_node("Arm").get_rotation_degrees()+3)
	
	if velocity.length() == 0:
		animations.play("face" + direction)
	else:
		animations.play("walk" + direction)

func initialize(stats : mobStats):
	maxHealth = stats.maxHealth
	currentHealth = stats.currentHealth
	speed = stats.speed
	strength = stats.strength
	rateOfFire = stats.rateOfFire
	gunAccuracy = stats.gunAccuracy
	ballisticResistance = stats.ballisticResistance
	laserResistance = stats.laserResistance
	plasmaResistance = stats.plasmaResistance
	bleedingResistance = stats.bleedingResistance
	fireResistance = stats.fireResistance
	explosionResistance = stats.explosionResistance
	slowResistance = stats.slowResistance
	stunResistance = stats.stunResistance

func shoot(check):
	if doShootToggle != check:
		if check == true:
			laser = projectile.instantiate()
			$Arm/Muzzle.add_child(laser)
			laser.setShooter(get_groups(), {"baseDamage": statModification.baseLaserDamage, "damageMultiplier": 1, "projectileRange": $Arm.projectileRange, "speed": $Arm.speed, "penetration": $Arm.penetration, "projectileMultiplier": $Arm.projectilesPerShot, "effectsOnHit": $Arm.effectsOnHit})
		else:
			laser.queue_free()
	doShootToggle = check

func getResistances():
	return {"ballisticResistance": ballisticResistance,"laserResistance": laserResistance,"plasmaResistance": plasmaResistance,"bleedingResistance": bleedingResistance,"fireResistance": fireResistance,"explosionResistance": explosionResistance,"slowResistance": slowResistance,"stunResistance": stunResistance}

func takeDamage(hit):
	currentHealth -= hit
	currentHealth = max(0, currentHealth)
	if currentHealth == 0:
		queue_free()

func heal(amount):
	currentHealth += amount
	currentHealth = min(currentHealth, maxHealth)
	emit_signal("healthChanged")

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished() == false:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		
		#makes enemy slow approach upon reaching certain distance
		"var mod = 1
		var distance = player.position - position
		if distance.length() <= stopDistance:
			mod = 0
		elif distance.length() < (2*stopDistance) and distance.length() > stopDistance:
			mod = (distance.length() - stopDistance) / stopDistance"
		
		var playerDistance = (player.position - position).length()
		if doShoot == false and playerDistance <= agroDistance:
			velocity = dir * speed#* mod
		else:
			velocity = dir * 0
		move_and_slide()
	
	updateAnimation()
	
	#testLineOfSight()
	if $Arm/Muzzle/RayCast2D.get_collider() != null:
		if $Arm/Muzzle/RayCast2D.get_collider().is_in_group("player") == true:
			doShoot = true
			#var damage = statModification.laserDamage(timer) * delta
			#playerStats.takeDamage(damage)
			#timer += delta
		else:
			doShoot = false
			#timer = 1.0
	else:
		doShoot = false
	shoot(doShoot)


#functions not associated with _physics_process:
func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
