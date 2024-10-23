@tool
extends RigidBody3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

@export var isAffectedByGravity = true

@export var targetTimer = 1.2
var timer = []

@export var minimumArcSeparation = 0.5
var arcs

var centerColor = Color(0.55, 0, 1, 1)
var pulse = 0

var player = null
var playerAttraction = 0

func _ready():
	arcs = $center.get_children()
	while len(timer) < len(arcs):
		timer.append(0)


func _process(delta):
	for i in range(len(arcs)):
		timer[i] -= delta
		if timer[i] <= 0:
			var originSet = false
			var origin
			
			#prevents arcs from being placed closer than minimumArcSeparation
			while originSet == false: 
				origin = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
				origin /= sqrt(pow(origin.x, 2) + pow(origin.y, 2) + pow(origin.z, 2))
				originSet = true
				for arc in arcs:
					if arc.get_child(3).position.distance_to(origin) < minimumArcSeparation:
						originSet = false
			
			#adds player attraction to arc vector
			if player != null:
				var playerVec = to_local(player.global_position)
				origin += playerVec * playerAttraction
				origin /= origin.length()
			
			#define arc origin and contact point
			var contactPoint = origin
			origin *= ($center.mesh.radius - 0.005)
			contactPoint *= ($glass.mesh.radius - 0.005)
			arcs[i].changeOriginPosition(origin)
			arcs[i].changeContactPosition(contactPoint)
			timer[i] = targetTimer + randf_range(-0.6, 0.6)
	
	#set player attraction if player is within Area3D
	if player != null:
		playerAttraction = clamp(($Area3D/CollisionShape3D.shape.radius * 1.5) / ((player.global_position - global_position).length() + 0.5) - 0.8, 0, 10)
		#$center.mesh.material.emission = centerColor - (Color(0.4, 0, 0, 0) * playerAttraction)
		pulse += delta * (playerAttraction + 1)
		$center.mesh.material.emission_energy_multiplier = 5.5 + (playerAttraction * 2 * (0.8 + sin(6 * pulse)))
		#$AudioStreamPlayer3D.attenuation_filter_cutoff_hz = 5000 - (2450 * (1 + sin(6 * pulse + 1)))
		$AudioStreamPlayer3D.volume_db = (sin(6 * pulse + 1) - 1) * 4 * (1 + playerAttraction/2)
		player.changeHealth((-1.2 * playerAttraction - 1) * delta)


func _integrate_forces(state):
	if isAffectedByGravity == true:
		state.apply_force(physicsHandler.globalGravity * physicsHandler.globalGravityDir * mass)


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		player = body


func _on_area_3d_body_exited(body):
	if body is CharacterBody3D:
		player = null
		playerAttraction = 0
		pulse = 0
		$center.mesh.material.emission = centerColor
		$center.mesh.material.emission_energy_multiplier = 5.5
		$AudioStreamPlayer3D.attenuation_filter_cutoff_hz = 5000
		$AudioStreamPlayer3D.volume_db = 0
