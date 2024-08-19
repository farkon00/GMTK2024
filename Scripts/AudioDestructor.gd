extends Node


func _ready() -> void:
	connect("finished", destroyer)

func destroyer():
	queue_free()
