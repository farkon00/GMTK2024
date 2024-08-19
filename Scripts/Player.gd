class_name Player
extends Ship

const laser_base = Vector2(30, -1)
const add_laser_res = preload("res://Textures/Laser/laser_blue.png")
const remove_laser_res = preload("res://Textures/Laser/laser_red.png")
const audio_stream_player = preload("res://Nodes/player_audio_player.tscn")

func die():
	var audio_player = audio_stream_player.instantiate()
	$"..".add_child(audio_player)
	audio_player.play()
	super()
	GameManager.instance.gameover()

func process_laser_display():
	var laser: Sprite2D = $Laser
	if GameManager.instance.currently_changing == null:
		laser.visible = false
		return

	var laser_state = GameManager.instance.currently_changing.laser_state
	if laser_state == 1:
		laser.texture = add_laser_res
	elif laser_state == -1:
		laser.texture = remove_laser_res

	laser.scale.x = (GameManager.instance.currently_changing.position - position - laser_base).length()
	laser.position = laser_base + (GameManager.instance.currently_changing.position - position - laser_base) / 2
	laser.rotation = (GameManager.instance.currently_changing.position - position - laser_base).angle()
	laser.visible = true

func _process(_delta):
	process_laser_display()
