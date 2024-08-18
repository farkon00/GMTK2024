class_name Planet
extends SpaceBody

static var G = 4000
@export var density: float = 80
@export var mass: float = 300
@export var mass_min: float = 50
@export var mass_max: float = 3000
@export var laser_speed: float = 300
var laser_state: int = 0

func get_force_vector(pos: Vector2):
	return G * mass / (position - pos).length_squared() * (position - pos).normalized()

func _process(delta):
	if GameManager.instance.is_game_stopped: return
	if $"CollisionShape2D".shape.get_rect().has_point(get_local_mouse_position()):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			laser_state = 1
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			laser_state = -1
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && laser_state == 1:
		laser_state = 0
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) && laser_state == -1:
		laser_state = 0
	mass += laser_speed * delta * laser_state
	mass = min(max(mass, mass_min), mass_max)
	
	scale = Vector2(1, 1) * sqrt(mass / density)
