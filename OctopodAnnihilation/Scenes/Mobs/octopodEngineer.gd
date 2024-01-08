extends CharacterBody2D

const speed = 75
@export var stopDistance: int = 40
@export var meleeDistance: int = 64
@export var agroDistance: int = 800
var timer = 0
var meleeCooldown = 1

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@onready var animations = $AnimationPlayer
var direction = "Down"

func _ready() -> void:
	nav_agent.target_desired_distance = stopDistance

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

func hit():
	
	pass

func _physics_process(delta: float) -> void:
	var playerDistance = (player.position - position).length()
	
	if nav_agent.is_navigation_finished() == false:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		
		#makes enemy slow approach upon reaching certain distance
		"var mod = 1
		var distance = player.position - position
		if distance.length() <= stopDistance:
			mod = 0
		elif distance.length() < (2*stopDistance) and distance.length() > stopDistance:
			mod = (distance.length() - stopDistance) / stopDistance"
		
		#creates agro distance
		if playerDistance <= agroDistance:
			velocity = dir * speed#* mod
		else:
			velocity = dir * 0
		move_and_slide()
	
	updateAnimation()
	
	#melee attack cooldown
	timer += delta
	if playerDistance <= meleeDistance:
		if timer >= meleeCooldown:
			hit()
			timer = 0
