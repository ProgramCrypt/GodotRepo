extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var shooter = null
var propertiesDict = {"damage": 0, "swingRange": 30, "swingDirection": 0, "swingAngle": 360, "swingSpeed": 0.5, "effectsOnHit": []}


func _ready():
	pass

func _process(delta):
	propertiesDict["swingSpeed"] -= delta
	if propertiesDict["swingSpeed"] <= 0:
		queue_free()
	#print(str(get_rotation_degrees()) + " " + str(get_angle_to(Vector2(0,0))*(180/PI)))

func setProperties(shooterGroups, shooterPropertiesDict):
	propertiesDict = shooterPropertiesDict
	if "player" in shooterGroups:
		shooter = "player"
	elif "npc" in shooterGroups:
		shooter = "npc"
	else:
		shooter = "enemy"
	$CollisionShape2D.shape.radius = propertiesDict["swingRange"]
	rotation = propertiesDict["swingDirection"]

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		print(str(rotation_degrees) + " " + str(abs(get_angle_to(body.get_node("CollisionShape2D").global_position)*(180/PI))) + " " + str(propertiesDict["swingAngle"]/2))
	if shooter == "player" or shooter == "npc":
		if body.is_in_group("player") == true or body.is_in_group("npc") == true:
			pass
		elif body.is_in_group("enemy") == true:
			if abs(get_angle_to(body.get_node("CollisionShape2D").global_position)*(180/PI)) <= propertiesDict["swingAngle"]/2:
				var damage = propertiesDict["damage"]
				body.takeDamage(damage)
	
	if shooter == "enemy":
		if body.is_in_group("enemy"):
			pass
		elif body.is_in_group("player") == true:
			if abs(get_angle_to(body.get_node("CollisionShape2D").global_position)*(180/PI)) <= propertiesDict["swingAngle"]/2:
				var damage = propertiesDict["damage"]
				body.takeDamage(damage)
