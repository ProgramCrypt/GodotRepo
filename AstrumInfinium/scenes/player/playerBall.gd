extends RigidBody3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var controlForce = 1

const mouseSensitivity = 0.1

var knownGravity = Vector3(0, -1, 0)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity))
		$head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		$head.rotation.x = clamp($head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _integrate_forces(state):
	state.apply_force(physicsHandler.globalGravity * physicsHandler.globalGravityDir)
	
	# handle game exit
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	#if is_on_floor(): #stops the player from changing velocity mid-air
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		state.apply_force(direction * controlForce)
	else:
		state.apply_force(direction * 0)
