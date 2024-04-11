extends StaticBody2D

@export var health = 20


func _on_area_2d_area_entered(area):
	if 'projectile' in area.get_groups():
		health -= area.projectileProperties["damage"]
		if health <= 10 and health > 0:
			$Sprite2D.frame = 9
		elif health <= 0:
			$Sprite2D.frame = 10
			$Area2D.set_deferred("monitoring", false)
	
	if 'melee' in area.get_groups():
		health -= area.propertiesDict["damage"]
		if health <= 10 and health > 0:
			$Sprite2D.frame = 9
		elif health <= 0:
			$Sprite2D.frame = 10
			$Area2D.set_deferred("monitoring", false)
