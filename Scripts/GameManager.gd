class_name GameManager
extends Node

static var instance: GameManager
var is_game_stopped: bool = false
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

func win():
	is_game_stopped = true
	$"YouWinUI".set_process(true)
	$"YouWinUI".visible = true