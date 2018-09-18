extends TileMap

var data = null

# Draw map cells from map 2DArray
func draw_map( map ):
	for x in range( map.size() ):
		for y in range( map[x].size() ):
			set_cell( x,y, map[x][y] )


func _ready():
	RPG.map = self
	
	
	data = dun_gen.Generate()
	draw_map( data.map )
	
	#RPG.map_size = Vector2(data.map.size(), data.map[0].size())
	
	# Astar representation
	Astar_map.build_map(Vector2(data.map.size(), data.map[0].size()), dun_gen.get_floor_cells()) 
	
	call_deferred("spawn_player")

func spawn_player():
	var player = RPG.make_entity( "player/player" )
	spawn(player, data.start_pos)
	#call_deferred("spawn", player, data.start_pos)
	RPG.player = player
	var ob = RPG.player
	ob.fighter.connect("hp_changed", RPG.game.playerinfo, "hp_changed")
	ob.fighter.emit_signal("hp_changed",ob.fighter.hp, ob.fighter.max_hp)
	#spawn(player, data.start_pos)
	#spawn( player, Vector2( 2,2 ) )


# Return TRUE if cell is a floor on the map
func is_floor( cell ):
	return get_cellv( cell ) == 0

func get_entities_in_cell(cell):
	var list = []
	for obj in get_tree().get_nodes_in_group('entity'):
		if obj.get_map_position() == cell:
			list.append(obj)
	return list

# Turn-based
func _on_player_acted():
	for node in get_tree().get_nodes_in_group('entity'):
		if node != RPG.player and node.ai:
			#print(node.get_name() + " gives you a dirty look!")
			node.ai.take_turn()
	
# Return False if cell is an unblocked floor
# Return Object if cell has a blocking Object
func is_cell_blocked(cell):
	var blocks = not is_floor(cell)
	var entities = get_entities_in_cell(cell)
	for e in entities:
		if e.block_move:
			blocks = e
	return blocks


# Spawn what path from Database, set position to where
func spawn( what, where ):
	print("Spawning: " + str(what.get_name()) + " @: " + str(where))
	# Add the entity to the scene and set its pos
	add_child( what )
	#what.set_map_pos( where )
	what.set_map_position(where)
	#print("Map position set " + str(where))