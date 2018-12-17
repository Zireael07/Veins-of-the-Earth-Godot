extends Node

# Return an instance of a node in that database at 'path'
func spawn( path ):
	# Find our entity before we try returning anything
	var entity = get_node( path )
	if entity:
		var nw_ent = entity.duplicate()
		# we need to store the path to properly restore when loading game
		nw_ent.original = path
		return nw_ent
	# Print an error message if entity doesn't come out
	print( "Cannot find an entity at: " + path )