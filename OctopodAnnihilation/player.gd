extends CharacterBody2D

@export var speed: int = 150
@onready var animations = $AnimationPlayer
var direction = "Down"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
func updateAnimation():
	if velocity.length() == 0:
		animations.play("face" + direction)
	else:
		if velocity.y < 0: direction = "Up"
		elif velocity.y > 0: direction = "Down"
		elif velocity.x < 0: direction = "Right"
		elif velocity.x > 0: direction = "Right"
	
		animations.play("walk" + direction)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	handleInput()
	move_and_slide()
	updateAnimation()
