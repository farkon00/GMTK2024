class_name Meteoride
extends SpaceBody

var speed: float

func _process(delta):
	$"..".progress_ratio += delta * speed / 100
	if $"..".progress_ratio == 1:
		free()
