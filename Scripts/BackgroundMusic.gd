class_name BackgroundMusic
extends AudioStreamPlayer


@onready var dummy_player = AudioStreamPlayer.new()
@export var fade_speed = 60
var fading = false
var menu_music = preload("res://Music/menu.mp3")
var level_music = preload("res://Music/level.mp3")

func _ready() -> void:
	add_child(dummy_player)



func _process(delta: float) -> void:
	if fading:
		volume_db -= fade_speed * delta
		dummy_player.volume_db += fade_speed * delta

		if dummy_player.volume_db >= 0:
			volume_db = 0
			dummy_player.volume_db = -60

			stream = dummy_player.stream
			play(dummy_player.get_playback_position())

			dummy_player.stop()
			fading = false

func start_fade_play():
	dummy_player.volume_db = -60
	dummy_player.play()
	fading = true

func play_menu():
	dummy_player.stream = menu_music
	start_fade_play()

func play_level():
	dummy_player.stream = level_music
	start_fade_play()
