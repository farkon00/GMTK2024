class_name Player
extends Ship

const laser_base = Vector2(30, -1)
const add_laser_res = preload("res://Textures/Laser/laser_blue.png")
const remove_laser_res = preload("res://Textures/Laser/laser_red.png")

func die():
	super()
	GameManager.instance.gameover()

func _process(_delta):
	var planets = $"../Planets".get_children() as Array[Planet]
	var laser_state = 0
	for planet in planets:
		if planet.laser_state != 0:
			laser_state = planet.laser_state
			break

	var laser: Sprite2D = $Laser
	if laser_state == 1:
		laser.texture = add_laser_res
	elif laser_state == -1:
		laser.texture = remove_laser_res

	if laser_state != 0:
		laser.scale.x = (get_global_mouse_position() - position - laser_base).length()
		laser.position = laser_base + (get_global_mouse_position() - position - laser_base) / 2
		laser.rotation = (get_global_mouse_position() - position - laser_base).angle()
		laser.visible = true
	else:
		laser.visible = false
