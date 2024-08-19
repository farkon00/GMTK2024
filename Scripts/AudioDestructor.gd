extends Node


func _ready() -> void:
	connect("finished", free)

