extends Node2D

# class member variables go here, for example:
# for spawning
var original	
	
var direction = Vector2()

var target_pos = Vector2()
export var block_move = false

var grid
# The map_to_world function returns the position of the tile's top left corner in isometric space,
# we have to offset the objects on the Y axis to center them on the tiles
var tile_offset = Vector2(0,0)
var tile_size = Vector2(0,0)

# components
var fighter
var ai
var item
var container

var dead = false

var splash_base = preload("res://splash.tscn")


func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("entity")
	
	set_z_index(1)
	
	# set ourselves to invisible
	set_visible(false)
	
	#grid = get_parent().get_node("TileMap")
	grid = get_parent()
	tile_size = grid.get_cell_size()
	tile_offset = Vector2(0, tile_size.y / 2)
	
	$"Label".set_text(get_name())
	$"Label".hide()

func kill():
	if RPG.player != self:
		broadcast_kill()
		queue_free()
	
	dead = true

func remove():
	queue_free()


func broadcast_kill():
	RPG.broadcast(self.name + " is killed!", RPG.COLOR_LIGHT_GREY)

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
	
func update_position(pos, direction):
	var grid_pos = grid.world_to_map(pos)

	var new_grid_pos = grid_pos + direction

	var target_pos = grid.map_to_world(new_grid_pos) + tile_offset
	
	# Print statements help to understand what's happening. We're using GDscript's string format operator % to convert
	# Vector2s to strings and integrate them to a sentence. The syntax is "... %s" % value / "... %s ... %s" % [value_1, value_2]
	#print("Pos %s, dir %s" % [pos, direction])
	#print("Grid pos, old: %s, new: %s" % [grid_pos, new_grid_pos])
	#print(target_pos)
	
	return [target_pos, new_grid_pos]

func update_position_map(map_pos, direction):
	var new_grid_pos = map_pos + direction

	var target_pos = grid.map_to_world(new_grid_pos) + tile_offset
	
	# Print statements help to understand what's happening. We're using GDscript's string format operator % to convert
	# Vector2s to strings and integrate them to a sentence. The syntax is "... %s" % value / "... %s ... %s" % [value_1, value_2]
	#print("Pos %s, dir %s" % [pos, direction])
	#print("Grid pos, old: %s, new: %s" % [grid_pos, new_grid_pos])
	#print(target_pos)
	
	return [target_pos, new_grid_pos]
	
func step_to(cell):
	var map_pos = get_map_position()
	var path = Astar_map.find_path(map_pos, cell)
	if path != null and path.size() > 1:
		#print("Path: " + str(path))
		var dir = path[1] - map_pos
		#print("Dir: " + str(dir))
		var res = update_position_map(map_pos, dir)
		print("AI has moved!!! " + str(res))
		
		# Check if unblocked
		var blocker = grid.is_cell_blocked(res[1])
		if not blocker:
			set_position(res[0]+Vector2(0,-8))
		# detect when we bump something
		else:
			if typeof(blocker) == TYPE_OBJECT:
				if blocker.fighter:
					fighter.fight(blocker)
		
		# since we use Astar, we don't have to check if the cell is blocked or not
		#set_position(res[0]+Vector2(0,-8))

func distance_to(cell):
	var line = FOV_gen.get_line(get_map_position(), cell)
	return line.size() - 1

# Get our Icon texture
func get_icon():
	return get_node('Sprite').get_texture()

func add_splash(type=0,dmg=null):
	var splash = splash_base.instance()
	
	# set values
	splash.type = type
	if dmg:
		splash.dmg = dmg
	add_child(splash)


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func save():
	print("Saving... " + str(self.name))
	var data = {}
	data.name = self.name
	# this didn't work properly, lost editable info
	# from where we were loaded
	#data.filename = get_filename()
	# original path in Database
	data.original = self.original

	var pos = get_map_position()
	data.x = pos.x
	data.y = pos.y
	
	data.visible = self.is_visible()
	
	# save components
	if item:
		data.item = item.save()
	if fighter:
		data.fighter = fighter.save()
	if ai:
		data.ai = ai.save()
	
	return data
	
func restore(data):
	if 'name' in data:
		self.name = data.name
		
	# x,y are handled by the map instead
	
	if item and 'item' in data:
		item.restore(data.item)
	if fighter and 'fighter' in data:
		fighter.restore(data.fighter)
	if ai and 'ai' in data:
		ai.restore(data.ai)
	
	self.set_visible(data.visible)
	
	return self
	
func spawn(map,cell):
	print("Spawning " + self.get_name() + " at " + str(cell))
	map.add_child(self, true) # legible names
	set_map_position(cell)
	
	# fpr chaining
	return self