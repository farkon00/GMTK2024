class_name Missile
extends CharacterBody2D

@export var movement_speed: float = 100 

var direction: Vector2
var gravity_velocity: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos_delta = movement_speed * delta * direction
	var planets = $"../Planets".get_children() as Array[Planet]
	var gravity_acceleration = Vector2()
	for planet in planets:
		gravity_acceleration += planet.get_force_vector(position)
	gravity_velocity += gravity_acceleration * delta
	pos_delta += gravity_velocity * delta
	rotation = pos_delta.angle()
	position += pos_delta
	
