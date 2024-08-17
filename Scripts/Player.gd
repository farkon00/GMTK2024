class_name Player
extends StaticBody2D

@export var initial_hearts_count = 3

const heart_res = preload("res://Nodes/heart.tscn")

var hearts: Array[TextureRect] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(initial_hearts_count):
		var heart = heart_res.instantiate()
		hearts.append(heart)
		$"Hearts/HBoxContainer".add_child(heart)


func _on_area_2d_body_entered(body):
	if body is Missile:
		body.free()
		hearts.back().free()
		hearts.pop_back()
		if hearts.is_empty():
			get_tree().quit()
