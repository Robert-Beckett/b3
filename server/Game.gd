extends Node2D

var players = {}
var leaderboard = {}
var base_ship = preload("res://Player.tscn")
var map = preload("res://maps/Map01.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _server_created():
	# Need a function to generate map here.
	pass

func _player_added(id, name, ship):
	print("ADDING PLAYER ", id, " to ", self.name)
	# var player_ship = base_ship.instance()
	if (!players.has(id)):
		players[id] = {
			'id': id,
			'name': name,
			'ship_type': ship,
			'alive': false,
			'mouse_pos': [0, 0],
			'position': {
				'x': 0,
				'y': 0
			},
			'rotation': 0,
			'acceleration': 0,
			'velocity': 0,
			'collision_mask': 0,
			'collision_layer': 0,
			
		}
		_render_player_list()
		var player_ship = base_ship.instance()
		player_ship.name = str(id)
		player_ship.player_name = name
		player_ship.boat_selected = ship
		self.add_child(player_ship)
		leaderboard[id] = { 'name': name, 'score': 0 }
		

func _player_removed(id):
	print("REMOVING ", id)
	self.remove_child(get_node(str(id)))
	players.erase(id)
	leaderboard.erase(id)
	render_leaderboard()
	_render_player_list()
	rpc_unreliable("despawn_player", id)

func _render_player_list():
	$ItemList.clear()
	for player in players:
		$ItemList.add_item(str(player))


# Spawns all existing players for a single player
func spawn_players(id, p_name):
	for player in players:
		if (player != id):
			rpc_id(id, "spawn_player", player, players[player].name, players[player].ship_type, players[player].alive)

# Spawns a single player for all existing players.
func spawn_player(id, p_name):
	for player in players:
		rpc_id(player, "spawn_player", id, p_name, players[id].ship_type, players[id].alive)
	
remote func spawn_for(p_name):
	var player_id = get_tree().get_rpc_sender_id()
	spawn_players(player_id, p_name)
	spawn_player(player_id, p_name)
	render_leaderboard()

remote func get_spawn_point():
	var player_id = get_tree().get_rpc_sender_id()

# Always called to increase a score.
remote func set_score(p_owner):
	update_leaderboard(p_owner)

func update_leaderboard(p_owner):
	leaderboard[int(p_owner)].score += 1
	rpc_unreliable("update_leaderboard", leaderboard)
	

func render_leaderboard():
	rpc_unreliable("update_leaderboard", leaderboard)




































