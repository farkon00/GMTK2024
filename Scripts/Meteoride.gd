class_name Meteoride
extends SpaceBody

var speed: float

func _ready():
	rotation = randf() * TAU

func _process(delta):
	$"..".progress_ratio += delta * speed / 100
	if $"..".progress_ratio >= 1:
		$"..".queue_free()
