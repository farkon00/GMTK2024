class_name Portal
extends SpaceBody

@export var connects_to: Portal
var recently_teleported: Array[Missile] = []

func _on_area_2d_body_entered(body: Node2D):
	if !body is Missile: return
	if connects_to.recently_teleported.has(body): return
	super(body)

func _on_teleportation_area_body_entered(body: Node2D):
	if !(body is Missile): return
	if connects_to.recently_teleported.has(body): return
	body.position = connects_to.position + Vector2(0, body.position.y - position.y)
	recently_teleported.append(body)
	await get_tree().create_timer(0.3).timeout
	recently_teleported.erase(body)
