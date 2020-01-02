extends Node2D

var players = {}

var base_ship = preload("res://Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("..").connect("player_joined_room", self, "_player_added")
	get_node("..").connect("player_left_room", self, "_player_removed")

func _server_created():
	# Need a function to generate map here.
	pass

func _player_added(id):
	print("ADDING PLAYER", id)
	# var player_ship = base_ship.instance()
	if (!players.has(id)):
		players[id] = {
			'id': id,
			'name': "Player",
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
		self.add_child(player_ship)

func _player_removed(id):
	players.erase(id)
	_render_player_list()

func _render_player_list():
	$ItemList.clear()
	for player in players:
		$ItemList.add_item(str(player))

# Spawns all existing players for a single player
func spawn_players(id):
	for player in players:
		if (player != id):
			rpc_id(id, "spawn_player", players[player])

# Spawns a single player for all existing players.
func spawn_player(id):
	for player in players:
		rpc_id(player, "spawn_player", players[id])
	
remote func spawn_for():
	var player_id = get_tree().get_rpc_sender_id()
	spawn_players(player_id)
	spawn_player(player_id)

remote func set_score(p_owner):
	get_node(p_owner).score += 1
	print(get_node(p_owner).score, " ", p_owner)






































