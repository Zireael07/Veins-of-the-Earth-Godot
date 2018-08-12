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
	
	#set_process(true)
	#pass

func update_position(pos, direction):
	var grid_pos = grid.world_to_map(pos)

	var new_grid_pos = grid_pos + direction

	var target_pos = grid.map_to_world(new_grid_pos) + tile_offset
	
	# Print statements help to understand what's happening. We're using GDscript's string format operator % to convert
	# Vector2s to strings and integrate them to a sentence. The syntax is "... %s" % value / "... %s ... %s" % [value_1, value_2]
	print("Pos %s, dir %s" % [pos, direction])
	print("Grid pos, old: %s, new: %s" % [grid_pos, new_grid_pos])
	#print(target_pos)
	return target_pos


func _input(event):
	direction = Vector2()
	
#	if event is InputEventKey:
#		if event.pressed:
#			print(event.scancode)
	
	if Input.is_action_just_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_just_pressed("move_down"):
		direction.y = 1
	
	if Input.is_action_just_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_just_pressed("move_right"):
		direction.x = 1

	if direction != Vector2():
		target_pos = update_position(get_position(), direction)
		set_position(target_pos+Vector2(0,-8))
