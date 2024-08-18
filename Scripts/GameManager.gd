class_name GameManager
extends Node

static var instance: GameManager
var is_game_stopped: bool = false
var currently_changing: Planet = null
var enemy_ships: Array[EnemyShip] = []

func _init():
    instance = self

func _ready():
    for child in $"..".get_children():
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
    var planets = $"../Planets".get_children() as Array[Planet]
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
    $"YouWinUI".set_process(true)
    $"YouWinUI".visible = true
