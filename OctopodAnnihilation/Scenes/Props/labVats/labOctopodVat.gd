extends StaticBody2D

@export var health = 25


func _on_area_2d_area_entered(area):
	if 'projectile' in area.get_groups():
		health -= area.projectileProperties["damage"]
		if health <= 0:
			$Sprite2D.frame = 20
			$Area2D.set_deferred("monitoring", false)
			$CollisionShape2D.shape.size = Vector2(39, 35)
			$CollisionShape2D.position = Vector2(0.5, 16)
	
	if 'melee' in area.get_groups():
		health -= area.propertiesDict["damage"]
		if health <= 0:
			$Sprite2D.frame = 20
			$Area2D.set_deferred("monitoring", false)
			$CollisionShape2D.shape.size = Vector2(39, 35)
			$CollisionShape2D.position = Vector2(0.5, 16)
