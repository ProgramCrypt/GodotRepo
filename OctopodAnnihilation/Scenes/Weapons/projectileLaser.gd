extends Area2D

@export var speed = 100

func _physics_process(delta):
	position -= transform.x * speed * delta

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
