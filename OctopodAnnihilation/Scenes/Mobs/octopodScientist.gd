extends CharacterBody2D

const speed = 75
@export var stopDistance: int = 150

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@onready var animations = $AnimationPlayer
var direction = "Down"

@export var testProjectile: PackedScene
var currentTestProjectile
var testProjectileList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var doShoot = false
var doShootToggle = false
var laser = null
@export var projectile: PackedScene
#var shootTimer = 

func _ready() -> void:
	nav_agent.target_desired_distance = stopDistance
#	makepath()

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

func testLineOfSight():
	currentTestProjectile = RandomNumberGenerator.new().randf()
	testProjectileList.append(currentTestProjectile)
	var b = testProjectile.instantiate()
	owner.add_child(b)
	b.transform = $Arm/Muzzle.global_transform
	b.createID(currentTestProjectile)
	testProjectileList.pop_front()

func toggleShoot(ID, target):
	if testProjectileList.has(ID):
		if target == "player":
			doShoot = true
		else:
			doShoot = false

func shoot(check):
	if doShootToggle != check:
		if check == true:
			laser = projectile.instantiate()
			$Arm/Muzzle.add_child(laser)
			#laser.transform = $Arm/Muzzle.transform
		else:
			laser.queue_free()
	doShootToggle = check

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished() == false:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		
		#makes enemy slow approach upon reaching certain distance
		"var mod = 1
		var distance = player.position - position
		if distance.length() <= stopDistance:
			mod = 0
		elif distance.length() < (2*stopDistance) and distance.length() > stopDistance:
			mod = (distance.length() - stopDistance) / stopDistance"
		
		if doShoot == false:
			velocity = dir * speed#* mod
		else:
			velocity = dir * 0
		move_and_slide()
	
	updateAnimation()
	
	"var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.position, $Arm/Muzzle.position, collision_mask, [self])
	var result = space_state.intersect_ray(query)
	print(result)"
	
	testLineOfSight()
	shoot(doShoot)


#functions not associated with _physics_process:
func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
