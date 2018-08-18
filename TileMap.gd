extends TileMap

func _ready():
	# Test objects
	var player = RPG.make_entity( "player/player" )
	spawn( player, Vector2( 2,2 ) )

# Return TRUE if cell is a floor on the map
func is_floor( cell ):
	return get_cellv( cell ) == 0

# Spawn what path from Database, set position to where
func spawn( what, where ):
	# Add the entity to the scene and set its pos
	add_child( what )
	#what.set_map_pos( where )
	what.set_map_position(where)