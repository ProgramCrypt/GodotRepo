extends StaticBody2D


var neutral : Color = Color("F9cff9")
var warning : Color = Color("Fea3fe")

var state = neutral

func _draw():
	var width = $CollisionShape2D.shape.size.x
	var height = $CollisionShape2D.shape.size.y
	
	draw_line(Vector2(-width/2, height/2), Vector2(width/2, height/2), state, 2)
	draw_line(Vector2(width/2, (height+2)/2), Vector2(width/2, -(height+2)/2), state, 2)
	draw_line(Vector2(width/2, -height/2), Vector2(-width/2, -height/2), state, 2)
	draw_line(Vector2(-width/2, -(height+2)/2), Vector2(-width/2, (height+2)/2), state, 2)


func setPosition(pos):
	position = pos
