extends CharacterBody3D

signal healthChanged(health)

@onready var physicsHandler = get_node("/root/PhysicsHandler")

@export var interactHint : PackedScene
@export var pauseMenu : PackedScene


var normalSpeed = 4.0
var speed = normalSpeed
const jumpVelocity = 3.5
var direction
var mass = 45

var cameraSensitivity = 1

var knownGravity = Vector3(0, -1, 0)

# Movement directions are redefined each frame based on player's local coordinates so that they can change in global space upon the gravity changing
var forward = Vector3(0, 0, 0)
var backward = Vector3(0, 0, 0)
var right = Vector3(0, 0, 0)
var left = Vector3(0, 0, 0)

# Used to handle the player's rotation upon the gravity changing
var oldRot
var newRot
var rotDifference
var activeRot = false
var rotTimer = 0

var hintActive = false
var hintTimer = 0

var maxHealth = 10
var currentHealth = maxHealth
var regenRate = 5
var noRegenActive = false
var noRegenTimer = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	call_deferred('emit_signal', 'healthChanged', currentHealth)
	
	physicsHandler.initialPlayerTransform = transform


func _input(event):
	if event is InputEventMouseMotion and activeRot == false:
		rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-event.relative.x * 0.1 * cameraSensitivity)) # Handles left/right camera movement
		$neck/head.rotate_x(deg_to_rad(-event.relative.y * 0.1 * cameraSensitivity)) # Handles up/down camera movement
		$neck/head.rotation.x = clamp($neck/head.rotation.x, deg_to_rad(-85), deg_to_rad(85)) # Restricts up/down camera movement to within plus or minus 85 degrees 


func changeHealth(value):
	currentHealth += value
	if value < 0:
		noRegenActive = true
	if currentHealth >= maxHealth:
		currentHealth = maxHealth
	elif currentHealth <= 0:
		death()
	emit_signal('healthChanged', currentHealth)


func death():
	get_tree().reload_current_scene()


func _physics_process(delta):
	# regen health
	if currentHealth < maxHealth and noRegenActive == false:
		changeHealth(regenRate * delta)
	else:
		noRegenTimer += delta
		if noRegenTimer >= 1:
			noRegenActive = false
			noRegenTimer = 0
	
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
		physicsHandler.gravShift(newGravDir)
	
	# handle interaction
	if Input.is_action_just_pressed("interact"):
		var collider = $neck/head/RayCast3D.get_collider()
		if collider != null:
			if collider.is_in_group("gravShifter"):
				collider.shiftGravity()
	
	# show hints
	if $neck/head/RayCast3D.get_collider() != null:
		if $neck/head/RayCast3D.get_collider().is_in_group("interactable"):
			hintTimer += delta
			if hintTimer >= 1.0:
				var hint = interactHint.instantiate()
				get_tree().root.add_child(hint)
				$crosshair/CenterContainer/ColorRect.visible = false
				$crosshair/CenterContainer/ColorRect2.visible = false
			if hintActive == false:
				$crosshair/CenterContainer/ColorRect.color = Color(0.4, 0.9, 0.5, 1.0)
				$crosshair/CenterContainer/ColorRect2.color = Color(0.4, 0.9, 0.5, 1.0)
				$crosshair/CenterContainer/ColorRect.custom_minimum_size = Vector2(4, 30)
				$crosshair/CenterContainer/ColorRect2.custom_minimum_size = Vector2(30, 4)
				$crosshair/CenterContainer/ColorRect3.color = Color(0.4, 0.9, 0.5, 1.0)
			hintActive = true
		else:
			hintTimer = 0
			var hintArray = get_tree().get_nodes_in_group("hint")
			for hint in hintArray:
				hint.queue_free()
				$crosshair/CenterContainer/ColorRect.visible = true
				$crosshair/CenterContainer/ColorRect2.visible = true
			if hintActive == true:
				$crosshair/CenterContainer/ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
				$crosshair/CenterContainer/ColorRect2.color = Color(1.0, 1.0, 1.0, 1.0)
				$crosshair/CenterContainer/ColorRect.custom_minimum_size = Vector2(2, 20)
				$crosshair/CenterContainer/ColorRect2.custom_minimum_size = Vector2(20, 2)
				$crosshair/CenterContainer/ColorRect3.color = Color(1.0, 1.0, 1.0, 1.0)
			hintActive = false
	else:
		hintTimer = 0
		var hintArray = get_tree().get_nodes_in_group("hint")
		for hint in hintArray:
			hint.queue_free()
			$crosshair/CenterContainer/ColorRect.visible = true
			$crosshair/CenterContainer/ColorRect2.visible = true
		if hintActive == true:
			$crosshair/CenterContainer/ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
			$crosshair/CenterContainer/ColorRect2.color = Color(1.0, 1.0, 1.0, 1.0)
			$crosshair/CenterContainer/ColorRect.custom_minimum_size = Vector2(2, 20)
			$crosshair/CenterContainer/ColorRect2.custom_minimum_size = Vector2(20, 2)
			$crosshair/CenterContainer/ColorRect3.color = Color(1.0, 1.0, 1.0, 1.0)
		hintActive = false
	
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
		var menu = pauseMenu.instantiate()
		get_tree().root.call_deferred('add_child', menu)
	
	# Get the input direction and handle the movement/deceleration.
	var vy = velocity.normalized().dot(physicsHandler.globalGravityDir) * velocity.length() * physicsHandler.globalGravityDir # Saves vertical component of velocity from previous frame
	var vxz = velocity - vy # Saves horizontal component of velocity from previous frame to add to this frame's velocity if the player is falling
	
	velocity = Vector3(0, 0, 0) # Sets new velocity to zero so that the player moves at a constant rate rather than accelerating each physics frame
	
	# Sets this frame's velocity to the current horizontal directional input
	var inputVector = Input.get_vector("left", "right", "forward", "backward")
	if inputVector != Vector2(0, 0):
		inputVector = Vector3(inputVector.x, 0, inputVector.y).rotated($neck/up.global_position - global_position, rotation.y)
		if is_on_floor():
			velocity += inputVector * speed
		else: #  If player is falling, this lets them accelerate horizontally up to their max speed. The 5 integer just controls how fast they can accelerate
			if (vxz + (inputVector * 5 * delta)).length() < speed:
				vxz += inputVector * 5 * delta
	
	'if Input.is_action_pressed("forward"):
		forward = $neck/forward.global_position - global_position
		if is_on_floor():
			velocity += forward * speed
		else: # If player is falling, this lets them accelerate horizontally up to a maximum value
			if (vxz + (forward * 5 * delta)).dot(forward) < (forward * speed * 1.41).dot(forward):
				vxz += forward * 5 * delta
	
	if Input.is_action_pressed("backward"):
		backward = $neck/backward.global_position - global_position
		if is_on_floor():
			velocity += backward * speed
		else:
			if (vxz + (backward * 5 * delta)).dot(backward) < (backward * speed * 1.41).dot(backward):
				vxz += backward * 5 * delta
	
	if Input.is_action_pressed("right"):
		right = $neck/right.global_position - global_position
		if is_on_floor():
			velocity += right * speed
		else:
			if (vxz + (right * 5 * delta)).dot(right) < (right * speed * 1.41).dot(right):
				vxz += right * 5 * delta
	
	if Input.is_action_pressed("left"):
		left = $neck/left.global_position - global_position
		if is_on_floor():
			velocity += left * speed
		else:
			if (vxz + (left * 5 * delta)).dot(left) < (left * speed * 1.41).dot(left):
				vxz += left * 5 * delta'
	
	# Adds horizontal velocity from previous physics frame if the player is falling so that they retain momentum
	if is_on_floor() == false: 
		velocity += vxz
	
	# Adds any vertical velocity the player had from the previous frame
	velocity += vy
	
	move_and_slide()
	
	# handle RigidBody3D collisions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_force(-c.get_normal() * mass)
