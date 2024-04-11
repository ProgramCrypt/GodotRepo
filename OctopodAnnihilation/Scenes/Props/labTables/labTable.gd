extends StaticBody2D

@export var health = 15


func _on_area_2d_area_entered(area):
	if 'projectile' in area.get_groups():
		health -= area.projectileProperties["damage"]
		if health <= 0:
			$Sprite2D.frame = 15
			$Area2D.set_deferred("monitoring", false)
			$CollisionShape2D.set_deferred("disabled", true)
			z_index = -2
	
	if 'melee' in area.get_groups():
		health -= area.propertiesDict["damage"]
		if health <= 0:
			$Sprite2D.frame = 15
			$Area2D.set_deferred("monitoring", false)
			$CollisionShape2D.set_deferred("disabled", true)
			z_index = -2
