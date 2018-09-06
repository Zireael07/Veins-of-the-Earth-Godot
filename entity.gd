extends Node2D

# class member variables go here, for example:
var direction = Vector2()

var target_pos = Vector2()
export var block_move = false

var grid
# The map_to_world function returns the position of the tile's top left corner in isometric space,
# we have to offset the objects on the Y axis to center them on the tiles
var tile_offset = Vector2(0,0)
var tile_size = Vector2(0,0)

func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("entity")
	
	
	#grid = get_parent().get_node("TileMap")
	grid = get_parent()
	tile_size = grid.get_cell_size()
	tile_offset = Vector2(0, tile_size.y / 2)

func get_map_position():
	var grid_pos = grid.world_to_map(get_position()-Vector2(0,-8))
	
	return grid_pos

func set_map_position(pos):
	var new_grid_pos = pos #grid.map_to_world(pos)
	var target_pos = grid.map_to_world(pos) + tile_offset
	
	# Print statements help to understand what's happening. We're using GDscript's string format operator % to convert
	# Vector2s to strings and integrate them to a sentence. The syntax is "... %s" % value / "... %s ... %s" % [value_1, value_2]
	print("Pos %s, dir %s" % [pos, direction])
	print("Grid pos new: %s" % [new_grid_pos])
	#print(target_pos)
	
	set_position(target_pos+Vector2(0,-8))

	return [target_pos, new_grid_pos]
	
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
