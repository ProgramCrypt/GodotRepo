@tool
extends StaticBody3D

@export var lineRadius = 0.01
@export var lineResolution = 180

@export var updatePerTime = 0.2
var timer = 0

@export var numberOfArcs = 4
@export var arcOffsetFraction = 0.8


func changeOriginPosition(originPosition):
	$handle1.position = originPosition


func changeContactPosition(contactPosition):
	$handle2.position = contactPosition


func _ready():
	pass


func _process(delta):
	timer += delta
	if timer >= updatePerTime:
		var circle = PackedVector2Array()
		for degree in lineResolution:
			var x = lineRadius * sin(PI * 2 * degree / lineResolution)
			var y = lineRadius * cos(PI * 2 * degree / lineResolution)
			var coords = Vector2(x, y)
			circle.append(coords)
		$MeshInstance3D.polygon = circle
		
		var origin = $handle1.position
		var contactPoint = $handle2.position
		$MeshInstance3D.material.set('shader_parameter/origin', origin)
		$MeshInstance3D.material.set('shader_parameter/contactPoint', contactPoint)
		var totalSegmentLen = (contactPoint - origin).length() / (numberOfArcs + 1)
		var xLen = (contactPoint.x - origin.x) / (numberOfArcs + 1)
		var yLen = (contactPoint.y - origin.y) / (numberOfArcs + 1)
		var zLen = (contactPoint.z - origin.z) / (numberOfArcs + 1)
		$Path3D.curve.clear_points()
		$Path3D.curve.add_point(origin) # - global_position
		for i in range(numberOfArcs):
			var point = origin
			randomize()
			point.x += (xLen * (i+1)) + randf_range(-arcOffsetFraction*totalSegmentLen, arcOffsetFraction*totalSegmentLen)
			point.y += (yLen * (i+1)) + randf_range(-arcOffsetFraction*totalSegmentLen, arcOffsetFraction*totalSegmentLen)
			point.z += (zLen * (i+1)) + randf_range(-arcOffsetFraction*totalSegmentLen, arcOffsetFraction*totalSegmentLen)
			$Path3D.curve.add_point(point) # - global_position
		$Path3D.curve.add_point(contactPoint) # - global_position
		timer = 0
