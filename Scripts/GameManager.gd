class_name GameManager
extends Node

@export var levels: Array[PackedScene] = []
@export var level_box: Node
@export var timer_label: Label
@export var finish_time_label: Label

@export var laser_sound: AudioStreamPlayer

static var instance: GameManager

var is_game_stopped: bool = true
var level_timer_ms: float = 0 
var timer_paused: bool = false
var currently_changing: Planet = null
var enemy_ships: Array[EnemyShip] = []
enum states {MainMenu, LevelSelect}
var state_behind_settings = states.MainMenu

var sfx_volume: float = 50
var music_volume: float = 50

var mouse_on_sfx = false
var mouse_on_music = false

var currently_changing_sfx = false
var currently_changing_music = false

func _init():
	instance = self

func set_active(node: Node, value: bool):
	node.set_process(value)
	node.visible = value

func initialize_level(id: int):
	var current_level = $"../Level"
	if current_level != null:
		current_level.free()
	current_level = levels[id].instantiate()
	$"..".add_child(current_level)
	$"..".move_child(current_level, 0)
	set_active($"TimerUI", current_level.get_meta("has_timer"))
	is_game_stopped = false
	currently_changing = null
	level_timer_ms = 0

	enemy_ships.clear()
	for child in current_level.get_node("EnemyShips").get_children():
		if child is EnemyShip:
			enemy_ships.append(child)

func level_selected(id: int):
	$"BackgroundMusic".play_level()
	set_active($"LevelSelectUI", false)
	initialize_level(id)

func _on_level_select_button_pressed():
	$"BackgroundMusic".play_menu()
	set_active($"YouWinUI", false)
	set_active($"GameOverUI", false)
	set_active($"LevelSelectUI", true)

func _ready():
	$"BackgroundMusic".play_menu()
	set_active($"YouWinUI", false)
	set_active($"GameOverUI", false)

	var buttons = level_box.get_children()
	for i in range(buttons.size()):
		buttons[i].connect("pressed", func (): level_selected(i))

func gameover():
	is_game_stopped = true
	set_active($"GameOverUI", true)
	set_active($"TimerUI", false)

func _input(event):
	if is_game_stopped || !(event is InputEventMouseButton): return
	if event.button_index != MOUSE_BUTTON_LEFT && event.button_index != MOUSE_BUTTON_RIGHT: return
	if !event.pressed:
		if currently_changing != null:
			currently_changing.laser_state = 0
		currently_changing = null
		return
	if currently_changing != null: return
	var planets = $"../Level/Planets".get_children() as Array[Planet]
	for planet in planets:
		if planet.get_node("CollisionShape2D").shape.get_rect().has_point(planet.get_local_mouse_position()):
			if event.button_index == MOUSE_BUTTON_LEFT:
				if !planet.tutorial_disabled_bigger:
					planet.laser_state = 1
					currently_changing = planet
			elif !planet.tutorial_disabled_smaller:
				planet.laser_state = -1
				currently_changing = planet
			return

func win():
	is_game_stopped = true
	if $"../Level".get_meta("has_timer"):
		finish_time_label.text = get_timer_string()
	set_active($"YouWinUI", true)
	set_active($"TimerUI", false)

func pad_digits(val: int, digit_cnt: int):
	assert(str(val).length() <= digit_cnt)
	var res = ""
	for _i in range(digit_cnt - str(val).length()):
		res += "0"
	res += str(val)
	return res

func get_timer_string():
	var timer_ms_rounded = int(level_timer_ms)
	return "{0}:{1}.{2}".format([
		pad_digits(timer_ms_rounded / 60000, 2), 
		pad_digits(timer_ms_rounded / 1000 % 60, 2),
		pad_digits(timer_ms_rounded % 1000, 3)
	])

func _process(delta: float):
	if !is_game_stopped && Input.is_action_just_pressed("QuitLevel"):
		is_game_stopped = true
		$"BackgroundMusic".play_menu()
		set_active($"LevelSelectUI", true)
		set_active($"TimerUI", false)

	if is_game_stopped && laser_sound.playing:
		laser_sound.stop()

	if !timer_paused:
		level_timer_ms += delta * 1000
	timer_label.text = get_timer_string()
	if currently_changing != null:
		if !laser_sound.playing:
			sync_sfx_volume(laser_sound)
			laser_sound.play()
	else:
		laser_sound.stop()

	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		currently_changing_sfx = false
		currently_changing_music = false

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if (mouse_on_sfx || currently_changing_sfx) && !currently_changing_music:
			sfx_volume = 100 * $"SettingsUI/Panel/SFX/ProgressBar".get_local_mouse_position().x / $"SettingsUI/Panel/SFX/ProgressBar".size.x
			sfx_volume = clamp(sfx_volume, 0, 100)
			$"SettingsUI/Panel/SFX/ProgressBar".value = sfx_volume
			currently_changing_sfx = true
		if (mouse_on_music || currently_changing_music) && !currently_changing_sfx:
			music_volume = 100 * $"SettingsUI/Panel/Music/ProgressBar".get_local_mouse_position().x / $"SettingsUI/Panel/Music/ProgressBar".size.x
			music_volume = clamp(music_volume, 0, 100)
			$"SettingsUI/Panel/Music/ProgressBar".value = music_volume
			currently_changing_music = true

func _on_play_button_pressed():
	set_active($"MainMenuUI", false)
	set_active($"LevelSelectUI", true)
	state_behind_settings = states.LevelSelect


func _on_settings_button_pressed() -> void:
	if state_behind_settings == states.MainMenu:
		$"MainMenuUI".set_process(false)
	elif state_behind_settings == states.LevelSelect:
		$"LevelSelectUI".set_process(false)
	set_active($"SettingsUI", true)


func _on_close_settings_button_pressed() -> void:
	set_active($"SettingsUI", false)
	if state_behind_settings == states.MainMenu:
		$"MainMenuUI".set_process(true)
	elif state_behind_settings == states.LevelSelect:
		$"LevelSelectUI".set_process(true)


func _on_sfx_bar_mouse_entered() -> void:
	mouse_on_sfx = true


func _on_sfx_bar_mouse_exited() -> void:
	mouse_on_sfx = false


func _on_music_bar_mouse_entered() -> void:
	mouse_on_music = true


func _on_music_bar_mouse_exited() -> void:
	mouse_on_music = false


func sync_sfx_volume(audio_stream_player: AudioStreamPlayer) -> void:
	audio_stream_player.volume_db = linear_to_db(sfx_volume / 100)
