extends CharacterBody3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var normalSpeed = 4.0
var speed = normalSpeed
const jumpVelocity = 3.5
var direction

const mouseSensitivity = 0.1

var knownGravity = Vector3(0, -1, 0)

var forward = Vector3(0, 0, 0)
var forwardCheck = false
var backward = Vector3(0, 0, 0)
var backwardCheck = false
var right = Vector3(0, 0, 0)
var rightCheck = false
var left = Vector3(0, 0, 0)
var leftCheck = false

var oldRot
var newRot
var rotDifference
var activeRot = false
var rotTimer = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion and activeRot == false:
		rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-event.relative.x * mouseSensitivity))
		$neck/head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		$neck/head.rotation.x = clamp($neck/head.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor(): #turns off gravity if player is already on the floor
	velocity += physicsHandler.globalGravity * physicsHandler.globalGravityDir * delta
	
	# handle player orientation
	if knownGravity != physicsHandler.globalGravityDir:
		knownGravity = physicsHandler.globalGravityDir
		up_direction = -1 * physicsHandler.globalGravityDir
		activeRot = true
	
	# handle changing rotation
	if activeRot == true:
		var newTransform = global_transform.looking_at((global_position + knownGravity), Vector3.UP)
		newTransform = newTransform.rotated_local(Vector3(1, 0, 0), PI/2)
		global_transform = global_transform.interpolate_with(newTransform, delta * 3 * 1/(1-rotTimer))
		rotTimer += delta
		if rotTimer >= 1:
			global_transform = newTransform
			activeRot = false
			rotTimer = 0
	
	# handle changing gravity
	if Input.is_action_just_pressed("rightClick"):
		var newGravDir = $neck/head/look.global_position - $neck/head.global_position
		physicsHandler.globalGravityDir = newGravDir
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity -= physicsHandler.globalGravityDir * jumpVelocity
	
	# handle sprint
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		speed = normalSpeed * 1.6
	if Input.is_action_just_released("sprint"):
		speed = normalSpeed
	
	# handle game exit
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	
	# Get the input direction and handle the movement/deceleration.
	var vy = velocity.normalized().dot(physicsHandler.globalGravityDir) * velocity.length() * physicsHandler.globalGravityDir
	
	velocity = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("forward"):
		forwardCheck = true
		forward = $neck/forward.global_position - global_position
		velocity += forward * speed
	else:
		forwardCheck = false
		forward = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("backward"):
		backwardCheck = true
		backward = $neck/backward.global_position - global_position
		velocity += backward * speed
	else:
		backwardCheck = false
		backward = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("right"):
		rightCheck = true
		right = $neck/right.global_position - global_position
		velocity += right * speed
	else:
		rightCheck = false
		right = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("left"):
		leftCheck = true
		left = $neck/left.global_position - global_position
		velocity += left * speed
	else:
		leftCheck = false
		left = Vector3(0, 0, 0)
	
	velocity += vy
	
	move_and_slide()
