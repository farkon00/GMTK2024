extends Node

var time: float = 0
enum states {Welcome, Ship, EnemyShip, EnemyShip2, Planets, Planets2, GoodLuck, Gaming}
var state: states = states.Welcome
var recorded_mass: float = 0

func _process(delta: float) -> void:
	if GameManager.instance.is_game_stopped:
		queue_free()
	time += delta
	if state == states.EnemyShip2 && get_node_or_null("../Missile") == null:
		$"Panel/ContinueLabel".visible = true
	elif state == states.Planets && $"../Planets/ShowcasePlanet".mass > 800:
		$"Panel/ContinueLabel".visible = true
	elif state == states.Planets2 && $"../Planets/ShowcasePlanet".mass < recorded_mass:
		$"Panel/ContinueLabel".visible = true

func _ready():
	for planet in $"../Planets".get_children():
		planet.tutorial_disabled_bigger = true
		planet.tutorial_disabled_smaller = true

func _input(event):
	if !(event is InputEventMouseButton): return
	if event.button_index != MOUSE_BUTTON_LEFT && event.button_index != MOUSE_BUTTON_RIGHT: return
	if !event.pressed: return
	if state == states.Welcome:
		state = states.Ship
		time = 0
		$"Panel/WelcomeLabel".visible = false
		$"Panel/ShipLabel".visible = true
		$"../Player".z_index = 11
	elif state == states.Ship && time >= 0.1:
		state = states.EnemyShip
		time = 0
		$"Panel/ShipLabel".visible = false
		$"Panel/EnemyShipLabel".visible = true
		$"../Player".z_index = 0
		$"../EnemyShips/EnemyShip".z_index = 11
	elif state == states.EnemyShip && time >= 0.1:
		state = states.EnemyShip2
		$"../EnemyShips/EnemyShip".launch_missile()
		$"../Missile".is_in_launch = false
		$"../Missile".z_index = 11
		$"../Planets".process_mode = Node.PROCESS_MODE_INHERIT
		$"Panel/EnemyShipLabel".visible = false
		$"Panel/EnemyShipLabel2".visible = true
		$"Panel/ContinueLabel".visible = false
	elif state == states.EnemyShip2 && $"../Missile" == null:
		state = states.Planets
		$"Panel/EnemyShipLabel2".visible = false
		$"Panel/PlanetsLabel".visible = true
		$"../EnemyShips/EnemyShip".z_index = 0
		$"../Planets/ShowcasePlanet".tutorial_disabled_bigger = false
		$"../Planets/ShowcasePlanet".z_index = 11
		$"../Player".z_index = 11
		$"Panel/ContinueLabel".visible = false
	elif state == states.Planets && $"../Planets/ShowcasePlanet".mass > 800:
		state = states.Planets2
		$"Panel/PlanetsLabel".visible = false
		$"Panel/PlanetsLabel2".visible = true
		$"../Planets/ShowcasePlanet".tutorial_disabled_bigger = true
		$"../Planets/ShowcasePlanet".tutorial_disabled_smaller = false
		$"Panel/ContinueLabel".visible = false
		recorded_mass = $"../Planets/ShowcasePlanet".mass
	elif state == states.Planets2 && $"../Planets/ShowcasePlanet".mass < recorded_mass:
		state = states.GoodLuck
		$"Panel/PlanetsLabel2".visible = false
		$"Panel/GoodLuck".visible = true
		$"Panel/ProTip".visible = true
		$"../Planets/ShowcasePlanet".tutorial_disabled_smaller = true
		$"../Player".z_index = 0
		$"../Planets/ShowcasePlanet".z_index = 0
	elif state == states.GoodLuck:
		state = states.Gaming
		$"Panel".visible = false
		$"../Planets".process_mode = Node.PROCESS_MODE_INHERIT
		$"../EnemyShips".process_mode = Node.PROCESS_MODE_INHERIT
		for planet in $"../Planets".get_children():
			planet.tutorial_disabled_bigger = false
			planet.tutorial_disabled_smaller = false
