extends CharacterBody2D

var speed: int
@onready var animations = $AnimationPlayer
@export var projectile: PackedScene
var hasWeapon = true
var direction = "Down"

#@onready var stats = $stats
@onready var playerStats = get_node("/root/ActivePlayerStats")

@export var playerType : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	playerStats.initialize(playerType)
	speed = playerStats.speed * 8

func handleInput(_delta):
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"): shoot()

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
	var b = projectile.instantiate()
	owner.add_child(b)
	b.transform = $Arm/Muzzle.global_transform
	b.setShooter(get_groups())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handleInput(delta)
	move_and_slide()
	updateAnimation()


