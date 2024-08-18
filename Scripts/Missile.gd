class_name Missile
extends CharacterBody2D

@export var movement_speed: float = 100 

const explosion_res = preload("res://Nodes/explosion_particles.tscn")

var direction: Vector2
var gravity_velocity: Vector2
var is_in_launch: bool = true

func explode():
	var emitter = explosion_res.instantiate() as Node2D
	get_tree().get_root().add_child(emitter)
	emitter.position = position + Vector2.from_angle(rotation) * ($"CollisionShape2D".shape as RectangleShape2D).size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.instance.is_gameover: return
	var pos_delta = movement_speed * delta * direction
	var planets = $"../Planets".get_children() as Array[Planet]
	var gravity_acceleration = Vector2()
	for planet in planets:
		gravity_acceleration += planet.get_force_vector(position)
	gravity_velocity += gravity_acceleration * delta
	pos_delta += gravity_velocity * delta
	rotation = pos_delta.angle()
	position += pos_delta
	var viewport_rect = get_viewport_rect()
	if position.x < 0 or position.y < 0 or position.x > viewport_rect.size.x or position.y > viewport_rect.size.y:
		explode()
		free()
	
