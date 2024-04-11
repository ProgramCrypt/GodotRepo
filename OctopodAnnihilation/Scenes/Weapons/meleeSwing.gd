extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var shooter = null
var propertiesDict = {"damageType": 0, "damage": 0, "swingRange": 30, "swingDirection": 0, "swingAngle": 360, "swingSpeed": 0.5, "effectsOnHit": []}

@export_range(1, 1000) var segments : int = 100
@export var width : int = 2
@export var color : Color = Color.GHOST_WHITE
@export var antialiasing : bool = false


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
	if shooter == "player" or shooter == "npc":
		if body.is_in_group("player") == true or body.is_in_group("npc") == true:
			pass
		elif body.is_in_group("enemy") == true:
			if abs(get_angle_to(body.get_node("CollisionShape2D").global_position)*(180/PI)) <= propertiesDict["swingAngle"]/2:
				if propertiesDict["damageType"] == 0:
					var damage = statModification.meleeDamage(propertiesDict["damage"], body.ballisticResistance, body.laserResistance)
					body.takeDamage(damage)
				if propertiesDict["damageType"] == 1:
					var damage = statModification.meleeDamage(propertiesDict["damage"], body.ballisticResistance, body.plasmaResistance)
					body.takeDamage(damage)
	
	if shooter == "enemy":
		if body.is_in_group("enemy"):
			pass
		elif body.is_in_group("player") == true:
			if abs(get_angle_to(body.get_node("CollisionShape2D").global_position)*(180/PI)) <= propertiesDict["swingAngle"]/2:
				if propertiesDict["damageType"] == 0:
					var damage = statModification.meleeDamage(propertiesDict["damage"], playerStats.ballisticResistance, playerStats.laserResistance)
					playerStats.takeDamage(damage)
				if propertiesDict["damageType"] == 1:
					var damage = statModification.meleeDamage(propertiesDict["damage"], playerStats.ballisticResistance, playerStats.plasmaResistance)
					playerStats.takeDamage(damage)


func _draw():
	# Calculate the arc parameters.
	var center = Vector2(0, 0)
	var radius = propertiesDict["swingRange"]
	var start_angle = -(propertiesDict["swingAngle"]*(PI/180))/2
	var end_angle = (propertiesDict["swingAngle"]*(PI/180))/2
	if end_angle < 0:  # end_angle is likely negative, normalize it.
		end_angle += TAU
	
	# Finally, draw the arc.
	draw_arc(center, radius, start_angle, end_angle, segments, color, width, antialiasing)
