extends Node

# Return an instance of a node in that database at 'path'
func spawn( path ):
	# Find our entity before we try returning anything
	var entity = get_node( path )
	if entity:
		return entity.duplicate()
	# Print an error message if entity doesn't come out
	print( "Cannot find an entity at: " + path )