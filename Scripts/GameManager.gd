class_name GameManager
extends Node

static var instance: GameManager
var is_gameover: bool = false

func _init():
	instance = self

func gameover():
	is_gameover = true
	$"GameOverUI".set_process(true)
	$"GameOverUI".visible = true
