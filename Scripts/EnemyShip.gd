class_name EnemyShip
extends Ship

@export var missile_launch_chance_second: float = 0.1
@export var initial_missile_timeout: float = 5
@export var missile_cooldown: float = 3

const missile_res = preload("res://Nodes/missile.tscn")
const audio_stream_player = preload("res://Nodes/enemy_audio_player.tscn")

var is_timedout = false

func start_timeout(duration: float):
	assert(!is_timedout)
	is_timedout = true
	await get_tree().create_timer(duration).timeout
	is_timedout = false


func _ready():
	super()
	start_timeout(initial_missile_timeout)

func launch_missile():
	var missile: Missile = missile_res.instantiate()
	missile.position = position
	missile.direction = ($"../../Player".position - position).normalized()
	$"../..".add_child(missile)
	start_timeout(missile_cooldown)

func process_missile_launching(delta: float):
	if !is_timedout && randf() < delta * missile_launch_chance_second:
		launch_missile()

func die():
	var audio_player = audio_stream_player.instantiate()
	$"..".add_child(audio_player)
	GameManager.instance.sync_sfx_volume(audio_player)
	audio_player.play()
	super()
	GameManager.instance.enemy_ships.erase(self)
	if GameManager.instance.enemy_ships.is_empty():
		GameManager.instance.win()

func _process(delta: float):
	if GameManager.instance.is_game_stopped: return
	process_missile_launching(delta)

func _on_area_2d_body_exited(body):
	if body is Missile:
		body.is_in_launch = false
