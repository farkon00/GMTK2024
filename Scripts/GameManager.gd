class_name GameManager
extends Node

@export var levels: Array[PackedScene] = []
@export var level_box: Node

static var instance: GameManager

var is_game_stopped: bool = true
var currently_changing: Planet = null
var enemy_ships: Array[EnemyShip] = []
var time_since_victory: float = 0
var has_won: bool = false

func _init():
	instance = self

func set_active(node: Node, value: bool):
	node.set_process(value)
	node.visible = value

func initialize_level(id: int):
	var current_level = $"../Level"
	if current_level != null:
		current_level.free()
	current_level = levels[id].instantiate()
	$"..".add_child(current_level)
	is_game_stopped = false
	has_won = false
	time_since_victory = 0
	currently_changing = null

	enemy_ships.clear()
	for child in current_level.get_node("EnemyShips").get_children():
		if child is EnemyShip:
			enemy_ships.append(child)

func level_selected(id: int):
	set_active($"LevelSelectUI", false)
	initialize_level(id)

func _on_level_select_button_pressed():
	set_active($"YouWinUI", false)
	set_active($"GameOverUI", false)
	set_active($"LevelSelectUI", true)

func _ready():
	set_active($"YouWinUI", false)
	set_active($"GameOverUI", false)
	
	var buttons = level_box.get_children()
	for i in range(buttons.size()):
		buttons[i].connect("pressed", func (): level_selected(i))

func gameover():
	is_game_stopped = true
	set_active($"GameOverUI", true)

func _input(event):
	if is_game_stopped || !(event is InputEventMouseButton): return
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
			if event.button_index == MOUSE_BUTTON_LEFT:
				if !planet.tutorial_disabled_bigger:
					planet.laser_state = 1
					currently_changing = planet
			elif !planet.tutorial_disabled_smaller:
				planet.laser_state = -1
				currently_changing = planet
			return

func win():
	is_game_stopped = true
	has_won = true
	set_active($"YouWinUI", true)

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
			set_active($"YouWinUI", false)
			initialize_level(new_level_id)
