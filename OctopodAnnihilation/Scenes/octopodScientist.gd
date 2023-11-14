extends CharacterBody2D

const speed = 75
@export var stopDistance: int = 150

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@onready var animations = $AnimationPlayer
@export var projectile: PackedScene
var direction = "Down"

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

func shoot():
	var b = projectile.instantiate()
	owner.add_child(b)
	b.transform = $Arm/Muzzle.global_transform

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished() == false:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		var distance = player.position - position
		var mod = 1
		if distance.length() <= stopDistance:
			mod = 0
		elif distance.length() < (2*stopDistance) and distance.length() > stopDistance:
			mod = (distance.length() - stopDistance) / stopDistance 
		velocity = dir * speed * mod
		move_and_slide()
	
	updateAnimation()
	shoot()

func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
