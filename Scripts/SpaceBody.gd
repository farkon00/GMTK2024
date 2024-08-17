class_name SpaceBody
extends StaticBody2D

func damage():
	pass

func _on_area_2d_body_entered(body):
	if body is Missile && !body.is_in_launch:
		body.explode()
		body.free()
		damage()
