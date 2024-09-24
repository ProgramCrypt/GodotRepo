extends StaticBody3D

@export var contactDamage = -10

var playerContact = false
var player = null


func _process(delta):
	if playerContact == true and player != null:
		player.changeHealth(contactDamage * delta)


func _on_area_3d_body_entered(body):
	if body.is_in_group('player'):
		player = body
		playerContact = true
		print('damage')


func _on_area_3d_body_exited(body):
	if body.is_in_group('player'):
		player = null
		playerContact = false
