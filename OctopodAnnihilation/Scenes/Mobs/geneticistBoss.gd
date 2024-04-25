extends CharacterBody2D

@export var enemyType : Resource

var modifiers = {}

var maxHealth : float
var currentHealth : float
var speed : float
var strength : float
var rateOfFire : float
var gunAccuracy : float
var ballisticResistance : float
var laserResistance : float
var plasmaResistance : float
var bleedingResistance : float
var fireResistance : float
var explosionResistance : float
var slowResistance : float
var stunResistance : float

@export var stopDistance: int = 30
@export var agroDistance: int = 200
@export var lineOfSightAgroDistance: int = 800

var player: Node2D

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@onready var animations = $AnimationPlayer
var direction = "Down"
var armSpeed = 5
var armSign = 1
var relativePlayerPos = Vector2(100, 100)
var playerAngle
var knownPlayerPosition = null

@export var plasmaProjectile: PackedScene
@export var octopodGrenade : PackedScene
var shootTimer = 0
var burstTimer = 0
var currentBursts = 0
var lineOfSight = false

var isPlayerCloaked = false
var stunned = false

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

@export var weaponType : Resource

@export var scrap: PackedScene


func _ready() -> void:
	nav_agent.target_desired_distance = stopDistance
	
	if get_tree().get_first_node_in_group("player") != null:
		player = get_tree().get_first_node_in_group("player")
	
	initialize(enemyType)
	speed = speed * 8
	
	$grenadeTimer.start(5)
	
	$Arm.initialize(weaponType)


func updateAnimation(delta):
	if (player.global_position - global_position).length() <= lineOfSightAgroDistance and isPlayerCloaked == false:
		relativePlayerPos = player.global_position - global_position
		if relativePlayerPos.length() <= lineOfSightAgroDistance:
			#handle arm rotation (convoluted garbage)
			playerAngle = atan(relativePlayerPos.y/relativePlayerPos.x)
			if (armSign * playerAngle) < 0:
				$Arm.set_rotation(-$Arm.get_rotation())
			$Arm.set_rotation($Arm.get_rotation()+((playerAngle-$Arm.get_rotation())*armSpeed*delta))
			armSign = playerAngle
			
			relativePlayerPos /= sqrt(relativePlayerPos.x*relativePlayerPos.x + relativePlayerPos.y*relativePlayerPos.y)
			if relativePlayerPos.x >= -0.70 and relativePlayerPos.x <= 0.70 and relativePlayerPos.y < 0:
				direction = "Up"
				get_node("Arm").set_z_index(-1)
				if relativePlayerPos.x < 0:
					get_node("Arm").scale.x = 1
				if relativePlayerPos.x > 0:
					get_node("Arm").scale.x = -1
				
			elif relativePlayerPos.x >= -0.70 and relativePlayerPos.x <= 0.70 and relativePlayerPos.y > 0:
				direction = "Down"
				get_node("Arm").set_z_index(0)
				if relativePlayerPos.x < 0:
					get_node("Arm").scale.x = 1
				if relativePlayerPos.x > 0:
					get_node("Arm").scale.x = -1
				
			elif relativePlayerPos.x < -0.70:
				direction = "Left"
				get_node("Arm").set_z_index(0)
				if relativePlayerPos.x < 0:
					get_node("Arm").scale.x = 1
				if relativePlayerPos.x > 0:
					get_node("Arm").scale.x = -1
				
			elif relativePlayerPos.x > 0.70:
				direction = "Right"
				get_node("Arm").set_z_index(-1)
				if relativePlayerPos.x < 0:
					get_node("Arm").scale.x = 1
				if relativePlayerPos.x > 0:
					get_node("Arm").scale.x = -1
	
	
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


func getResistances():
	return {"ballisticResistance": ballisticResistance,"laserResistance": laserResistance,"plasmaResistance": plasmaResistance,"bleedingResistance": bleedingResistance,"fireResistance": fireResistance,"explosionResistance": explosionResistance,"slowResistance": slowResistance,"stunResistance": stunResistance}


func takeDamage(hit):
	currentHealth -= hit
	currentHealth = max(0, currentHealth)
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:v", 1, 0.1).from(15)
	if currentHealth == 0:
		for i in range(10):
			get_parent().call_deferred("dropItem", scrap, global_transform)
		get_parent().call_deferred("removeForceFields")
		playerStats.playerScore += 200
		queue_free()


func heal(amount):
	currentHealth += amount
	currentHealth = min(currentHealth, maxHealth)
	emit_signal("healthChanged")


func shoot():
	var projectile = plasmaProjectile.instantiate()
	get_parent().get_parent().add_child(projectile)
	projectile.transform = $Arm/Muzzle.global_transform
	var fireAngle = randf_range(-$Arm.accuracy/2, $Arm.accuracy/2)
	projectile.rotation_degrees += fireAngle
	var projVector = Vector2.from_angle(projectile.rotation)
	projVector = -projVector
	var addedSpeed = velocity.dot(projVector)/2
	projectile.setShooter(get_groups(),{"damage": $Arm.damage, "projectileRange": $Arm.projectileRange, "projectileSpeed": $Arm.projectileSpeed + addedSpeed, "parentVelocity": velocity, "projectileSize": $Arm.projectileSize, "penetration": $Arm.penetration, "effectsOnHit": $Arm.effectsOnHit})


func throwGrenade():
	if $Arm/RayCast2D.get_collider() != null:
		if $Arm/RayCast2D.get_collider().is_in_group("player") == true:
			if randf() <= 1:
				var grenade = octopodGrenade.instantiate()
				get_parent().get_parent().add_child(grenade)
				grenade.global_position = $Arm/launcher.global_position
				#get_parent().dropItem(octopodGrenade, $Arm.global_transform)
				grenade.setVelocity(get_angle_to(player.global_position))


func _physics_process(delta: float) -> void:
	if stunned == false:
		var playerDistance = (player.global_position - global_position).length()
		if nav_agent.is_navigation_finished() == false or knownPlayerPosition != null:
			var dir = to_local(nav_agent.get_next_path_position()).normalized()
			
			#makes enemy slow approach upon reaching certain distance
			var mod = 1
			var distance = player.global_position - global_position
			if distance.length() <= stopDistance:
				mod = 0
			'elif distance.length() < (2*stopDistance) and distance.length() > stopDistance:
				mod = (distance.length() - stopDistance) / stopDistance'
			
			$lineOfSight.look_at(player.global_position)
			if playerDistance <= agroDistance and isPlayerCloaked == false:
				knownPlayerPosition = player.global_position
				if (knownPlayerPosition - global_position).length() >= 80:
					if $lineOfSight.get_collider() != null:
						if $lineOfSight.get_collider().is_in_group("player") == true:
							velocity = dir * 0
						else:
							velocity = dir * speed * mod
					else:
						velocity = dir * speed * mod
				else:
					velocity = dir * 0
			elif playerDistance <= lineOfSightAgroDistance and isPlayerCloaked == false:
				if $lineOfSight.get_collider() != null:
					if $lineOfSight.get_collider().is_in_group("player") == true:
						knownPlayerPosition = player.global_position
				if (knownPlayerPosition - global_position).length() >= 10:
					velocity = dir * speed * mod
				else:
					velocity = dir * 0
			else:
				velocity = dir * 0
			move_and_slide()
		
		updateAnimation(delta)
		
		if shootTimer >= 0:
			shootTimer -= delta
		
		if $Arm/RayCast2D.get_collider() != null:
			if $Arm/RayCast2D.get_collider().is_in_group("player") == true:
				lineOfSight = true
		
		if lineOfSight == true:
			burstTimer -= delta
			if shootTimer <= 0 and burstTimer <= 0:
				shoot()
				burstTimer = 0.2
				currentBursts += 1
				if currentBursts >= 8:
					shootTimer = 2
					currentBursts = 0
					lineOfSight = false


#functions not associated with _physics_process:
func makepath() -> void:
	if knownPlayerPosition == null:
		knownPlayerPosition = global_position
	nav_agent.target_position = knownPlayerPosition


func _on_timer_timeout():
	if (player.global_position - global_position).length() <= lineOfSightAgroDistance:
		makepath()
	pass


func playerCloaked(state):
	isPlayerCloaked = state


func _on_grenade_timer_timeout():
	throwGrenade()
