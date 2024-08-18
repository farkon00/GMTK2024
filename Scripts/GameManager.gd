class_name GameManager
extends Node

@export var levels: Array[PackedScene] = []

static var instance: GameManager

var is_game_stopped: bool = false
var currently_changing: Planet = null
var enemy_ships: Array[EnemyShip] = []
var time_since_victory: float = 0
var has_won: bool = false

func _init():
	instance = self

func _ready():
	for child in $"../Level/EnemyShips".get_children():
		if child is EnemyShip:
			enemy_ships.append(child)

func gameover():
	is_game_stopped = true
	$"GameOverUI".set_process(true)
	$"GameOverUI".visible = true

func _input(event):
	if !(event is InputEventMouseButton): return
	if event.button_index != MOUSE_BUTTON_LEFT && event.button_index != MOUSE_BUTTON_RIGHT: return
	if !event.pressed:
		if currently_changing != null:
			currently_changing.laser_state = 0
		currently_changing = null
		return
	if currently_changing != null: return
	var planets = $"../Level/Planets".get_children() as Array[Planet]
	for planet in planets:
		if planet.get_node("CollisionShape2D").shape.get_rect().has_point(planet.get_local_mouse_position()):
			currently_changing = planet
			if event.button_index == MOUSE_BUTTON_LEFT:
				planet.laser_state = 1
			else:
				planet.laser_state = -1
			return

func win():
	is_game_stopped = true
	has_won = true
	$"YouWinUI".set_process(true)
	$"YouWinUI".visible = true

func _process(delta):
	if has_won:
		time_since_victory += delta
	if time_since_victory >= 5:
		time_since_victory = 0
		var current_level = $"../Level"
		if current_level == null:
			return
		var new_level_id = current_level.get_meta("level_id") + 1
		if new_level_id == levels.size():
			# TODO: congrats gg screen
			pass
		else:
			current_level.free()
			current_level = levels[new_level_id].instantiate()
			$"..".add_child(current_level)
			is_game_stopped = false
			$"YouWinUI".set_process(false)
			$"YouWinUI".visible = false
