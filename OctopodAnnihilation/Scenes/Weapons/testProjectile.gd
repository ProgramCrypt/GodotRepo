extends Area2D

@export var speed = 2000
var ID = null

func _physics_process(delta):
	position -= transform.x * speed * delta

func createID(value):
	ID = value
	#print("val", blarfo)

func _on_body_entered(body):
	get_tree().call_group("projectileEnemies", "toggleShoot", ID, body.name)
	queue_free()
