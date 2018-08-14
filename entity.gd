extends Node2D

# class member variables go here, for example:
var direction = Vector2()

var target_pos = Vector2()

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
	
	grid = get_parent().get_node("TileMap")
	tile_size = grid.get_cell_size()
	tile_offset = Vector2(0, tile_size.y / 2)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
