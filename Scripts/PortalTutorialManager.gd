extends Node


var finished = false
func _ready():
    GameManager.instance.timer_paused = true

func _input(event):
    if !(event is InputEventMouseButton): return
    if event.button_index != MOUSE_BUTTON_LEFT: return
    if !event.pressed: return
    $"../Player".process_mode = Node.PROCESS_MODE_INHERIT
    $"../Planets".process_mode = Node.PROCESS_MODE_INHERIT
    $"../EnemyShips".process_mode = Node.PROCESS_MODE_INHERIT
    $"../Portal".z_index = 0
    $"../Portal2".z_index = 0
    $"Panel".visible = false
    GameManager.instance.timer_paused = false
    GameManager.instance.get_node("TimerUI").visible = true
    finished = true
    queue_free()

func _process(_delta: float):
    if GameManager.instance.is_game_stopped:
        queue_free()
    if !finished:
        GameManager.instance.get_node("TimerUI").visible = false

