extends Node2D

var player_ship = preload("res://Player.tscn")
var npc_ship = preload("res://NPC.tscn")
#var respawn_player_ship = preload("res://RealPlayer.tscn")
#var respawn_npc_ship = preload("res://NPCBoat.tscn")

var leader_board
var sorted_boi
# Called when the node enters the scene tree for the first time.
func _ready():
	# Announce ready to spawn here.
	rpc_id(1, "spawn_for", GameState.player_info.name)

func update_score(p_owner):
	rpc_unreliable_id(1, "set_score", p_owner)

	
remote func update_leaderboard(leaderboard_info):
	var sorted_leaderboard = []
	leader_board = leaderboard_info
	for leader in leaderboard_info:
		sorted_leaderboard.append({leaderboard_info[leader]['score']: { leader: leaderboard_info[leader]['name'] } })
	print (sorted_leaderboard)
	sorted_leaderboard.sort_custom(self, "sort_array_of_dict")
	print(sorted_leaderboard, " post sort")
	var player_id = get_tree().get_network_unique_id()
	get_node(str(player_id)).get_node('UI').get_node('HBoxContainer').get_node('./PlayerList').clear()
	get_node(str(player_id)).get_node('UI').get_node('HBoxContainer').get_node('./ScoreList').clear()
	sorted_boi = sorted_leaderboard
	var index = 0
	
	while index < 8 and index < sorted_leaderboard.size():
		if !sorted_leaderboard[index]:
			break
		var leader = sorted_leaderboard[index]
		var id = leader.values()[0].keys()[0]
		var name = leader.values()[0][id]
		var player_name

		if len(name) > 7:
			player_name = name.left(7) + "..."
		else:
			player_name = name
		get_node(str(player_id)).get_node('UI').get_node('HBoxContainer').get_node('./PlayerList').add_item(player_name)
		get_node(str(player_id)).get_node('UI').get_node('HBoxContainer').get_node('./ScoreList').add_item(str(leader.keys()[0]))
		index += 1
func sort_array_of_dict(a, b):
	if a.keys()[0] > b.keys()[0]:
		return true
	return false

remote func spawn_player(p_id, p_name, boat_type, alive):
	if (p_id == get_tree().get_network_unique_id()):
		var ship = player_ship.instance()
		ship.name = str(get_tree().get_network_unique_id())
		ship.player_name = p_name
		ship.boat_selected = boat_type
		self.add_child(ship)
		ship.map_limits = $Map01/Boundary.get_used_rect()
		ship.map_cellsize = $Map01/Boundary.cell_size
	else:
		var ship = npc_ship.instance()
		ship.name = str(p_id)
		ship.boat_selected = boat_type
		ship.player_name = p_name
		ship.alive = alive
		print(alive)
		self.add_child(ship)
		ship.initialize()

remote func despawn_player(p_id):
	if (get_node(str(p_id))):
		remove_child(get_node(str(p_id)))





























