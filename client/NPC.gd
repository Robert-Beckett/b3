extends Node2D

var player_init = {}
var p_name = "Not-Player"
var projectile = preload("res://Projectile.tscn")

var boat = preload("res://NPCboats/BigBoatNPC.tscn")

var p_owner

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_boat = boat.instance()
	add_child(new_boat)
	$NPCBoat.collision_layer = 1
	$NPCBoat.collision_mask = 1

remote func _spawn_projectile(projectile_type, _position, _direction, mask):
	var proj = projectile.instance()
	proj.p_owner = str(mask)
	add_child(proj)
	proj.start(_position, _direction)

func initialize():
	$NPCBoat.position.x = 0
	$NPCBoat.position.y = 0

remote func set_position(packet):
	if ($NPCBoat):
		$NPCBoat.position.x = packet.position.x
		$NPCBoat.position.y = packet.position.y
		$NPCBoat.rotation = packet.rotation
		$NPCBoat.acceleration = packet.acceleration
		$NPCBoat.velocity = packet.velocity
		$NPCBoat.mouse_pos = packet.mouse_pos

remote func update_health(hp):
	if $NPCBoat:
		$NPCBoat.update_health(hp)

remote func destroy():
	$NPCBoat.explode()

remote func respawn_player(x, y, rotation):
	var new_boat = boat.instance()
	new_boat.position.x = x
	new_boat.position.y = y
	new_boat.rotation = rotation
	add_child(new_boat)




























