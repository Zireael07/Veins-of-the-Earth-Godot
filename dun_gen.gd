extends Node

var map = []

# Generate the Datamap
# room_size = minimum and maximum w/h a room should have
func Generate(map_size=Vector2(20,20), room_count=35, room_size=Vector2(5,10), wall_id=1, floor_id=0):

	# Randomize
	randomize()

	# initialize data
	map = []
	var rooms = []
	var start_pos = Vector2()

	# Populate map array
	for x in range( map_size.x ):
		var column = []
		for y in range( map_size.y ):
			column.append( wall_id )
		map.append( column )
		
	for r in range( room_count ):
		# Roll Random Room Rect
		# Width & Height
		# No overlapping rooms
		var w = int( round( rand_range( room_size.x+2, room_size.y+2 ) ) )
		var h = int( round( rand_range( room_size.x +2, room_size.y+2 ) ) )
		# Origin (top-left corner)
		var x = int( round( rand_range( 0, map_size.x - w - 1 ) ) )
		var y = int( round( rand_range( 0, map_size.y - h - 1 ) ) )
		
		# Construct Rect2
		var new_room = Rect2( x, y, w, h )
		
		# Check against existing rooms for intersection
		if !rooms.empty():
			var passed = true
			for other_room in rooms:
				# If we don't intersect any other rooms..
				if new_room.intersects( other_room ):
					# Add to rooms list
					passed = false
			if passed: rooms.append(new_room)
		# Add the first room
		else:   rooms.append(new_room)
		
	# Process generated rooms
	for i in range( rooms.size() ):
		var room = rooms[i]
		# Carve room
		for x in range( room.size.x - 2 ):
			for y in range( room.size.y - 2 ):
				map[ room.position.x + x + 1 ][ room.position.y + y + 1] = floor_id
				
	# Tunnels
		if i == 0:
			# First room
			# Define the start_pos in the first room
			start_pos = center( room )
		else:
			# Carve a hall between this room and the last room
			var prev_room = rooms[i-1]
			var A = center( room )
			var B = center( prev_room )

			# Flip a coin..
			if randi() % 2 == 0:
				# carve vertical -> horizontal hall
				for cell in hline( A.x, B.x, A.y ):
					map[cell.x][cell.y] = floor_id
				for cell in vline( A.y, B.y, B.x ):
					map[cell.x][cell.y] = floor_id
			else:
				# carve horizontal -> vertical hall
				for cell in vline( A.y, B.y, A.x ):
					map[cell.x][cell.y] = floor_id
				for cell in hline( A.x, B.x, B.y ):
					map[cell.x][cell.y] = floor_id

			# Spawning
			place_monsters(room)
			
		# items
		place_items(room)


	# return data
	return {
		"map":      map,
		"rooms":    rooms,
		"start_pos":    start_pos,
		}
	
# Find the global center of a Rect2
func center( rect ):
	var x = ceil(rect.size.x / 2)
	var y = ceil(rect.size.y / 2)
	return rect.position + Vector2(x,y)
	
	
# Get Vector2 along x1 - x2, y
func hline( x1, x2, y ):
	var line = []
	for x in range( min(x1,x2), max(x1,x2) + 1 ):
		line.append( Vector2(x,y) )
	return line

# Get Vector2 along x, y1 - y2
func vline( y1, y2, x ):
	var line = []
	for y in range( min(y1,y2), max(y1,y2) + 1 ):
		line.append( Vector2(x,y) )
	return line

func get_floor_cells():
	var list = []
	for x in range( map.size() ):
		for y in range( map[x].size() ):
			if map[x][y] == 0:
				list.append(Vector2(x,y))
	
	return list
	
func place_monsters(room):
	print("Placing monsters...")
	var x = RPG.roll(room.position.x+1, room.end.x-2)
	var y = RPG.roll(room.position.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	
	var mon = RPG.make_entity("kobold/kobold")
	
	print("Place monster: " + str(mon) + " @ " + str(pos))
	
	RPG.map.spawn(mon, pos)
	
func place_items(room):
	print("Placing items...")
	var x = RPG.roll(room.position.x+1, room.end.x-2)
	var y = RPG.roll(room.position.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	
	var it = RPG.make_entity("potion/potion")
	
	print("Place item: " + str(it) + " @ " + str(pos))
	
	RPG.map.spawn(it, pos)