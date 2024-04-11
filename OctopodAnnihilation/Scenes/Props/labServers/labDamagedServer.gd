extends StaticBody2D

@export var health = 10


func _on_area_2d_area_entered(area):
	if 'projectile' in area.get_groups():
		health -= area.projectileProperties["damage"]
		if health <= 0:
			$Sprite2D.frame = 10
			$Area2D.set_deferred("monitoring", false)
	
	if 'melee' in area.get_groups():
		health -= area.propertiesDict["damage"]
		if health <= 0:
			$Sprite2D.frame = 10
			$Area2D.set_deferred("monitoring", false)
