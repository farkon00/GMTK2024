class_name Planet
extends StaticBody2D

static var G = 4000 
@export var mass: float = 300

func get_force_vector(pos: Vector2):
	return G * mass / (position - pos).length_squared() * (position - pos).normalized()
