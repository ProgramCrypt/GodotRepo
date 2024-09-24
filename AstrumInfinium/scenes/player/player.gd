extends CharacterBody3D

signal healthChanged(health)

@onready var physicsHandler = get_node("/root/PhysicsHandler")

@export var interactHint : PackedScene


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


func _input(event):
	if event is InputEventMouseMotion and activeRot == false:
		rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-event.relative.x * mouseSensitivity))
		$neck/head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		$neck/head.rotation.x = clamp($neck/head.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func changeHealth(value):
	currentHealth += value
	if value < 0:
		noRegenActive = true
	if currentHealth >= maxHealth:
		currentHealth = maxHealth
	elif currentHealth <= 0:
		death()
	emit_signal('healthChanged', currentHealth)
	print(currentHealth)


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
		if $neck/head/RayCast3D.get_collider().is_in_group("gravShifter"):
			hintTimer += delta
			if hintTimer >= 0.2:
				var hint = interactHint.instantiate()
				get_tree().root.add_child(hint)
		else:
			hintTimer = 0
			hintActive = false
			var hintArray = get_tree().get_nodes_in_group("hint")
			for hint in hintArray:
				hint.queue_free()
	else:
		hintTimer = 0
		hintActive = false
		var hintArray = get_tree().get_nodes_in_group("hint")
		for hint in hintArray:
			hint.queue_free()
	
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
	var vxz = velocity - vy
	
	velocity = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("forward"):
		forward = $neck/forward.global_position - global_position
		if is_on_floor():
			forwardCheck = true
			velocity += forward * speed
		else:
			if ((forward * 0.1) + vxz).length() <= vxz.length():
				vxz += forward * 4 * delta
	
	if Input.is_action_pressed("backward"):
		backward = $neck/backward.global_position - global_position
		if is_on_floor():
			backwardCheck = true
			velocity += backward * speed
		else:
			if ((backward * 0.1) + vxz).length() <= vxz.length():
				vxz += backward * 4 * delta
	
	if Input.is_action_pressed("right"):
		right = $neck/right.global_position - global_position
		if is_on_floor():
			rightCheck = true
			velocity += right * speed
		else:
			if ((right * 0.1) + vxz).length() <= vxz.length():
				vxz += right * 4 * delta
	
	if Input.is_action_pressed("left"):
		left = $neck/left.global_position - global_position
		if is_on_floor():
			leftCheck = true
			velocity += left * speed
		else:
			if ((left * 0.1) + vxz).length() <= vxz.length():
				vxz += left * 4 * delta
	
	# 
	
	if is_on_floor() == false:
		velocity += vxz
	
	velocity += vy
	
	move_and_slide()
