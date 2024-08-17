class_name Ship
extends StaticBody2D

@export var initial_hearts_count = 3

const heart_res = preload("res://Nodes/heart.tscn")

var hearts: Array[TextureRect] = []

func _ready():
	for i in range(initial_hearts_count):
		var heart = heart_res.instantiate()
		hearts.append(heart)
		$"Hearts/HBoxContainer".add_child(heart)

func die():
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Missile && !body.is_in_launch && !hearts.is_empty():
		body.explode()
		body.free()
		hearts.back().free()
		hearts.pop_back()
		if hearts.is_empty():
			die()
