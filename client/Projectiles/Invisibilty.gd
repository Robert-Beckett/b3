extends Area2D

onready var tween = get_node("Tween")
export var life = 4
# Called when the node enters the scene tree for the first time.
var p_owner
func start(_position, _direction):
	if get_parent().has_node("PlayerBoat"):
		var sprite = get_parent().get_node("PlayerBoat")
		tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0.5), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		sprite.invisible = true
		tween.start()
	if get_parent().has_node("NPCBoat"):
		var sprite = get_parent().get_node("NPCBoat")
		tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		get_parent().get_node("NPCBoat").get_node("Bar").hide()
		get_parent().get_node("NPCBoat").get_node("PlayerName").hide()
		sprite.invisible = true
		tween.start()
	$Lifetime.wait_time = life
	$Lifetime.start()

func _on_Lifetime_timeout():
	if get_parent().has_node("PlayerBoat"):
		get_parent().get_node("PlayerBoat").modulate.a = 1
		get_parent().get_node("PlayerBoat").invisible = false
	if get_parent().has_node("NPCBoat"):
		get_parent().get_node("NPCBoat").invisible = false
		get_parent().get_node("NPCBoat").modulate.a = 1
		get_parent().get_node("NPCBoat").get_node("Bar").show()
		get_parent().get_node("NPCBoat").get_node("PlayerName").show()
	queue_free()