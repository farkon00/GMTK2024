class_name Ship
extends SpaceBody

@export var initial_hearts_count = 3

const heart_res = preload("res://Nodes/heart.tscn")

var hearts: Array[TextureRect] = []

func _ready():
    for i in range(initial_hearts_count):
        var heart = heart_res.instantiate()
        hearts.append(heart)
        $"Hearts/HBoxContainer".add_child(heart)

func die():
    queue_free()

func damage():
    super()
    hearts.back().free()
    hearts.pop_back()
    if hearts.is_empty():
        die()
    else:
        GameManager.instance.sync_sfx_volume($"HitSound")
        $"HitSound".play()
