extends TileMap

var data = null

# Draw map cells from map 2DArray
func draw_map( map ):
	for x in range( map.size() ):
		for y in range( map[x].size() ):
			set_cell( x,y, map[x][y] )


func _ready():
	
	data = dun_gen.Generate()
	draw_map( data.map )
	
	
	# Test objects
	var player = RPG.make_entity( "player/player" )
	
	call_deferred("spawn", player, data.start_pos)
	#spawn(player, data.start_pos)
	#spawn( player, Vector2( 2,2 ) )

# Return TRUE if cell is a floor on the map
func is_floor( cell ):
	return get_cellv( cell ) == 0

# Spawn what path from Database, set position to where
func spawn( what, where ):
	# Add the entity to the scene and set its pos
	add_child( what )
	#what.set_map_pos( where )
	what.set_map_position(where)