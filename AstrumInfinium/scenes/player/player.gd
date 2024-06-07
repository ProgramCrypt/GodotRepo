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
	if event is InputEventMouseMotion:
		rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-event.relative.x * mouseSensitivity))
		$neck/head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		$neck/head.rotation.x = clamp($neck/head.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor(): #turns off gravity if player is already on the floor
	velocity += physicsHandler.globalGravity * physicsHandler.globalGravityDir * delta
	#print(physicsHandler.globalGravity * physicsHandler.globalGravityDir * delta)
	#print(velocity)
	
	# handle player orientation
	if knownGravity != physicsHandler.globalGravityDir:
		knownGravity = physicsHandler.globalGravityDir
		up_direction = -1 * physicsHandler.globalGravityDir
		var xGravDir = physicsHandler.globalGravityDir.x
		var yGravDir = physicsHandler.globalGravityDir.y
		var zGravDir = physicsHandler.globalGravityDir.z
		
		oldRot = rotation
		look_at(global_position + knownGravity)
		rotation += Vector3(PI/2, 0, 0)
		newRot = rotation
		rotation = oldRot
		rotDifference = newRot - oldRot
		activeRot = true
		
		'var targetPosition = global_position + knownGravity
		var newTransform = transform.looking_at(targetPosition, Vector3.UP)
		transform = transform.interpolate_with(newTransform, delta)'
		
		#Conflicting issue with xRot and zRot
		'var xRot
		var zRot
		if yGravDir <= 0:
			xRot = asin(zGravDir)
			zRot = asin(xGravDir)
		else:
			xRot = (PI/2) + ((PI/2) - asin(zGravDir))
			zRot = (PI/2) + ((PI/2) - asin(xGravDir))
		rotation = Vector3(xRot, rotation.y, zRot)'
		
		#Doesnt work
		'var yRot = acos(-yGravDir)
		var xRot = yRot * ((zGravDir**2))
		var zRot = yRot * ((xGravDir**2))
		rotation = Vector3(xRot, rotation.y, zRot)'
		
		#Doesnt work and fundementally rotates the player view incorrectly
		'var yzPlaneRot = acos(-yGravDir)
		var xzPlaneRot
		if xGravDir >= 0 and zGravDir > 0: #1st quadrant
			xzPlaneRot = atan(xGravDir/zGravDir)
		elif xGravDir >= 0 and zGravDir < 0: #2nd quadrant
			xzPlaneRot = PI - atan(xGravDir/abs(zGravDir))
		elif xGravDir < 0 and zGravDir < 0: #3rd quadrant
			xzPlaneRot = PI + atan(xGravDir/zGravDir)
		elif xGravDir < 0 and zGravDir > 0: #4th quadrant
			xzPlaneRot = -atan(abs(xGravDir)/zGravDir)
		elif xGravDir > 0 and zGravDir == 0:
			xzPlaneRot = PI/2
		elif xGravDir < 0 and zGravDir == 0:
			xzPlaneRot = -PI/2
		rotation = Vector3(yzPlaneRot, xzPlaneRot, 0)'
	
	# handle changing rotation
	if activeRot == true and rotation != newRot:
		rotTimer += 1.5 * delta
		if rotTimer < 0.5:
			rotation += rotDifference * 2 * delta
		else:
			rotation = newRot
			rotTimer = 0
			activeRot = false
	
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
	'var input_dir = Input.get_vector("left", "right", "forward", "backward")
	#if is_on_floor(): #stops the player from changing velocity mid-air
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)'
	
	if Input.is_action_pressed("forward"):
		forwardCheck = true
		forward = $neck/forward.global_position - global_position
		position += forward * speed * delta
	else:
		forwardCheck = false
		forward = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("backward"):
		backwardCheck = true
		backward = $neck/backward.global_position - global_position
		position += backward * speed * delta
	else:
		backwardCheck = false
		backward = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("right"):
		rightCheck = true
		right = $neck/right.global_position - global_position
		position += right * speed * delta
	else:
		rightCheck = false
		right = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("left"):
		leftCheck = true
		left = $neck/left.global_position - global_position
		position += left * speed * delta
	else:
		leftCheck = false
		left = Vector3(0, 0, 0)
	
	move_and_slide()
	
	'if forwardCheck == true: # THIS IS CAUSING THE MOVEMENT ISSUE BECAUSE IT TRIGGERS WHEN THE PLAYER ISNT MOVING BUT HOLDS DOWN THE KEYS
		velocity -= forward * speed
	
	if backwardCheck == true:
		velocity -= backward * speed
	
	if rightCheck == true:
		velocity -= right * speed
	
	if leftCheck == true:
		velocity -= left * speed'
	
