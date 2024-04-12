extends Area2D

@onready var playerStats = get_node("/root/ActivePlayerStats")
@onready var statModification = get_node("/root/StatModification")

var instantiator = "player"
var effect = "stun"

var apply = true
var affected = []

@export_range(1, 1000) var segments : int = 100
@export var width : int = 2
@export var color : Color = Color.ORANGE_RED
@export var antialiasing : bool = false


func setProperties(setInstantiator, setEffect, setDuration, setRadius):
	instantiator = setInstantiator
	effect = setEffect
	$CollisionShape2D.shape.radius = setRadius
	
	$applicationTimer.one_shot = true
	$applicationTimer.start(0.1)
	$durationTimer.one_shot = true
	$durationTimer.start(setDuration)


func _on_body_entered(body):
	if apply == true:
		if effect == "bleeding":
			bleeding(body)
		if effect == "fire":
			fire(body)
		if effect == "explosion":
			explosion(body)
		if effect == "stun":
			stun(body)
		if effect == "slow":
			slow(body)


func bleeding(body):
	if instantiator == "player":
		if "enemy" in body.get_groups():
			$bleedingTimer.start(0.6)
			affected.append(body)


func fire(body):
	pass


func explosion(body):
	if instantiator == "player":
		if "enemy" in body.get_groups():
			body.takeDamage(15)
			affected.append(body)
	if instantiator == "enemy":
		if "player" in body.get_groups() or "npc" in body.get_groups():
			playerStats.takeDamage(15)
			affected.append(body)


func stun(body):
	if instantiator == "player":
		if "enemy" in body.get_groups():
			body.stunned = true
			affected.append(body)


func slow(body):
	pass


func _draw():
	# Calculate the arc parameters.
	var center = Vector2(0, 0)
	var radius = $CollisionShape2D.shape.radius
	var start_angle = -PI
	var end_angle = PI
	if end_angle < 0:  # end_angle is likely negative, normalize it.
		end_angle += TAU
	
	# Finally, draw the arc.
	draw_arc(center, radius, start_angle, end_angle, segments, color, width, antialiasing)


func _on_application_timer_timeout():
	apply = false


func _on_duration_timer_timeout():
	for body in affected:
		if is_instance_valid(body):
			if effect == "bleeding":
				$bleedingTimer.stop()
			if effect == "stun":
				body.stunned = false
	queue_free()


func _on_bleeding_timer_timeout():
	for body in affected:
		if is_instance_valid(body):
			body.takeDamage(1)
