extends StaticBody3D

@onready var physicsHandler = get_node("/root/PhysicsHandler")

var knownGravity = Vector3(0, -1, 0)


func _ready():
	physicsHandler.gravityChanged.connect(setField, 1)
	call_deferred('setField')


func setField():
	#print(abs(physicsHandler.globalGravityDir.dot(global_transform.basis.y)))
	if abs(physicsHandler.globalGravityDir.dot(global_transform.basis.y)) >= 0.93:
		$CollisionShape3D.disabled = true
		$MeshInstance3D.mesh.material.set_shader_parameter('albedo', Color(0.9, 0.9, 1.0, 1.0))
		$MeshInstance3D2.mesh.material.set_shader_parameter('albedo', Color(0.9, 0.9, 1.0, 1.0))
	else:
		$CollisionShape3D.disabled = false
		$MeshInstance3D.mesh.material.set_shader_parameter('albedo', Color(1.0, 0.75, 0.7, 0.85))
		$MeshInstance3D2.mesh.material.set_shader_parameter('albedo', Color(1.0, 0.75, 0.7, 0.85))
