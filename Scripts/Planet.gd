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
    if GameManager.instance.is_gameover: return
    mass += laser_speed * delta * laser_state
    mass = min(max(mass, mass_min), mass_max)

    scale = Vector2(1, 1) * sqrt(mass / density)

