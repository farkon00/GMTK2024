class_name BackgroundMusic
extends AudioStreamPlayer


@onready var dummy_player = AudioStreamPlayer.new()
@export var fade_speed: float = 1 # speed in seconds
var fading = false
var menu_music = preload("res://Music/menu.mp3")
var level_music = preload("res://Music/level.mp3")

func _ready() -> void:
	add_child(dummy_player)



func _process(delta: float) -> void:
	if fading:
		var actual_speed = (linear_to_db(GameManager.instance.music_volume / 100) + 60) / fade_speed
		volume_db -= actual_speed * delta
		dummy_player.volume_db += actual_speed * delta

		if dummy_player.volume_db >= linear_to_db(GameManager.instance.music_volume / 100):
			volume_db = linear_to_db(GameManager.instance.music_volume / 100)
			dummy_player.volume_db = -60

			stream = dummy_player.stream
			play(dummy_player.get_playback_position())

			dummy_player.stop()
			fading = false
	else:
		volume_db = linear_to_db(GameManager.instance.music_volume / 100)

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
