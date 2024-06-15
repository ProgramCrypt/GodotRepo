extends CharacterBody3D


var normalSpeed = 5.0
var speed = normalSpeed
const jumpVelocity = 4.5

const mouseSensitivity = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity))
		$head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		$head.rotation.x = clamp($head.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity
	
	# handle sprint
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		speed = normalSpeed * 1.6
	if Input.is_action_just_released("sprint"):
		speed = normalSpeed
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
