class_name MeteorideWall
extends Path2D

@export var time_inverval: float = 0
@export var speed: float = 50
@export var meteoride: PackedScene
var time_since_spawn: float = 0

func _process(delta):
	time_since_spawn += delta
	if time_since_spawn >= time_inverval:
		var new_meteoride = meteoride.instantiate()
		new_meteoride.get_child(0).speed = speed
		add_child(new_meteoride)
		time_since_spawn = 0