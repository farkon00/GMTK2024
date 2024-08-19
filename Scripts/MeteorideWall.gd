class_name MeteorideWall
extends Path2D

@export var time_inverval: float = 0.3
@export var speed: float = 30

const meteoride: PackedScene = preload("res://Nodes/meteoride.tscn")

var time_since_spawn: float = 0

func _process(delta):
	if GameManager.instance.is_game_stopped:
		process_mode = Node.PROCESS_MODE_DISABLED
	time_since_spawn += delta
	if time_since_spawn >= time_inverval:
		var new_meteoride = meteoride.instantiate()
		new_meteoride.get_child(0).speed = speed
		add_child(new_meteoride)
		time_since_spawn = 0
