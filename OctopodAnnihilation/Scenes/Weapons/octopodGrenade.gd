extends RigidBody2D

@onready var animations = $AnimationPlayer

@export var effectArea : PackedScene

#var speed = 900
var distanceTraveled = 0
var totalDistance = 400
var triggerTimer = 0
var detonateTimer = 0
var detonate = false


func _ready():
	animations.play("static")
	linear_damp = 1.5
	#linear_velocity = Vector2(-600, 0)


func _process(delta):
	if linear_velocity.length() <= 50:
		linear_velocity = Vector2(0, 0)
	
	triggerTimer += delta
	if triggerTimer >= 1:
		animations.play("detonate")
		detonateTimer += delta
		if detonateTimer >= 1.8:
			if detonate == false:
				var explosion = effectArea.instantiate()
				get_parent().add_child(explosion)
				explosion.global_position = global_position
				explosion.setProperties("enemy", "explosion", 0, 200)
			else:
				queue_free()
			detonate = true


func setVelocity(angle, speed):
	linear_velocity = Vector2.from_angle(angle)
	linear_velocity *= speed
