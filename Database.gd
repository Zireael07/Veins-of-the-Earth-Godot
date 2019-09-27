extends Node

var greaves_gfx = preload("assets/boots2.png")

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

# this approach doesn't quite work, moved to actual spawning functions instead
# used to spawn several differing items from the same template
#func defer_edit(nw_ent, flag):
#	if flag == "armor":
#		var nm = nw_ent.get_name()
#		nw_ent.set_name(nm + " greaves")
#		nw_ent.readable_name == nw_ent.readable_name + " greaves"
#		nw_ent.get_node("Item").equip_slot == "LEGS"
#		nw_ent.get_node("Sprite").set_texture(greaves_gfx)	
#
#func spawn_edited(path, flag):
#	var nw_ent = spawn(path)
#
#	if nw_ent != null:
#		call_deferred("defer_edit", nw_ent, flag)
#
#	return nw_ent
