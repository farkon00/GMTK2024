class_name EnemyShip
extends StaticBody2D

@export var missile_launch_chance_second: float = 0.1
@export var initial_missile_timeout: float = 5
@export var missile_cooldown: float = 3

const missile_res = preload("res://Nodes/missile.tscn")

var is_timedout = false

func start_timeout(duration: float):
	assert(!is_timedout)
	is_timedout = true
	await get_tree().create_timer(duration).timeout
	is_timedout = false


func _ready():
	start_timeout(initial_missile_timeout)

func launch_missile():
	var missile: Missile = missile_res.instantiate()
	missile.position = position
	missile.direction = ($"../Player".position - position).normalized()
	$"..".add_child(missile)
	start_timeout(missile_cooldown)

func process_missile_launching(delta: float):
	if !is_timedout && randf() < delta * missile_launch_chance_second:
		launch_missile()

func _process(delta: float):
	process_missile_launching(delta)
