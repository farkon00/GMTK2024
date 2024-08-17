class_name Player
extends Ship

func die():
	super()
	GameManager.instance.gameover()
