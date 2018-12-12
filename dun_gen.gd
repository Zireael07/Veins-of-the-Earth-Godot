extends Node

var map = []

# BSP
var rect1
var rect2
var contain
var bak = []
var start_rect


func Generate_Town_BSP(map_size=Vector2(20,20), wall_id=1, floor_id=0):
	# Randomize
	randomize()
	
	# initialize data
	map = []
	var rooms = []
	var start_pos = Vector2()
	
	# x,y,w,h
	start_rect = [0,0,map_size.x, map_size.y]
	contain = [start_rect]
	
	# Populate map array
	for x in range( map_size.x ):
		var column = []
		for y in range( map_size.y ):
			column.append( floor_id )
		map.append( column )
	
	rect(contain)
	rect(contain)
	
	print(contain)
	
	for r in contain:
		# Construct Rect2
		var new_room = Rect2( r[0], r[1], r[2], r[3] )
		
		rooms.append(new_room)
	
		
	# Process generated rooms
	for i in range( rooms.size() ):
		var room = rooms[i]
		#print("Room: " + str(room))
		
		# Build walls
		for x in range(room.position.x, room.position.x + room.size.x - 1 ):
			for y in range(room.position.y, room.position.y + room.size.y - 1 ):
				map[ x + 1 ][ y + 1] = wall_id
		
		
		# Carve room
		for x in range(room.position.x+1, room.position.x + room.size.x - 2 ):
			for y in range(room.position.y+1, room.position.y + room.size.y - 2):
				map[ x + 1 ][ y + 1] = floor_id
	
		if i == 0:
			# First room
			# Define the start_pos in the first room
			start_pos = center( room )
		

			
		# items
		place_items(room)
	
	create_doors(rooms)
	
	# return data
	return {
		"map":      map,
		"rooms":    rooms,
		"start_pos":    start_pos,
		}
		
func create_doors(rooms):
	for room in rooms:
		var cent = center(room)
		
		var choices = ["north", "south", "east", "west"]
		
		var wall = choices[randi() % choices.size()]
		var wallX
		var wallY
		
		if wall == "north":
			wallX = cent.x
			wallY = room.position.y + 1
			print("N: " + str(wallX) + " " + str(wallY))
		elif wall == "south":
			wallX = cent.x
			wallY = room.end.y - 1
			print("S: " + str(wallX) + " " + str(wallY))
		elif wall == "east":
			wallX = room.end.x - 1
			wallY = cent.y
			print("E: " + str(wallX) + " " + str(wallY))
		elif wall == "west":
			wallX = room.position.x + 1
			wallY = cent.y
			print("W: " + str(wallX) + " " + str(wallY))
			
		map[wallX][wallY] = 0 # floor

func Generate_BSP(map_size=Vector2(20,20), wall_id=1, floor_id=3):
	# Randomize
	randomize()
	
	# initialize data
	map = []
	var rooms = []
	var start_pos = Vector2()
	
	# x,y,w,h
	start_rect = [0,0,map_size.x, map_size.y]
	contain = [start_rect]
	
	# Populate map array
	for x in range( map_size.x ):
		var column = []
		for y in range( map_size.y ):
			column.append( wall_id )
		map.append( column )
	
	rect(contain)
	rect(contain)
	
	print(contain)
	
	for r in contain:
		# Construct Rect2
		var new_room = Rect2( r[0], r[1], r[2], r[3] )
		
		rooms.append(new_room)
		
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
		
			if i == rooms.size()-1:
				print("Last room")
				# place stairs
				var cent = center(room)
				map[cent.x][cent.y] = 2 #stairs
			
		# items
		place_items(room)
	
	
	# return data
	return {
		"map":      map,
		"rooms":    rooms,
		"start_pos":    start_pos,
		}
	
	
func rect(contain):
	bak.clear()
	for rect in contain:
		randomize()
		if rect[2] > rect[3]:
			# 30-70% of width
			var w = round(rand_range(.3, .7)*rect[2])
			rect1 = [rect[0], rect[1], w, rect[3]]
			rect2 = [rect[0]+w, rect[1], rect[2]-w, rect[3]]
		else:
			var h = round(rand_range(.3, .7)*rect[3])
			rect1 = [rect[0], rect[1], rect[2], h]
			rect2 = [rect[0], rect[1]+h, rect[2], rect[3]-h]
			
		bak.append(rect1)
		bak.append(rect2)
		
	contain.clear()
	for r in bak:
		contain.append(r)	


# Generate the map
# room_size = minimum and maximum w/h a room should have
func Generate_random(map_size=Vector2(20,20), room_count=35, room_size=Vector2(5,8), wall_id=1, floor_id=0):

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
		
			if i == rooms.size()-1:
				print("Last room")
				# place stairs
				var cent = center(room)
				map[cent.x][cent.y] = 2 #stairs
			
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
			if map[x][y] in [0, 2, 3]: # 2 = stairs are walkable too!
				list.append(Vector2(x,y))
	
	return list
	
var monster_table = [ ["kobold", 80], ["drow", 20] ]
func get_chance_roll_table(chances, pad=false):
	var num = -1
	var chance_roll = []
	for chance in chances:
		#print(chance)
		var old_num = num + 1
		num += 1 + chance[1]
		# clip top number to 100
		if num > 100:
			num = 100
		chance_roll.append([chance[0], old_num, num])

	if pad:
		# pad out to 100
		print("Last number is " + str(num))
		# print "Last number is " + str(num)
		chance_roll.append(["None", num, 100])

	return chance_roll

# wants a table of chances [[name, low, upper]]
func random_choice_table(table):
	var roll = randi() % 101 # between 0 and 100
	print("Roll: " + str(roll))
	
	for row in table:
		if roll >= row[1] and roll <= row[2]:
			print("Random roll picked: " + str(row[0]))
			return row[0]
	

func place_monsters(room):
	print("Placing monsters...")
	var x = RPG.roll(room.position.x+1, room.end.x-2)
	var y = RPG.roll(room.position.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	
	# random select from a table
	var chance_roll_table = get_chance_roll_table(monster_table)
	print(chance_roll_table)
	
	var res = random_choice_table(chance_roll_table)
	print("Res: " + str(res))
	
	var mon
	if res == "kobold":
		mon = RPG.make_entity("kobold/kobold")
	elif res == "drow":
		mon = RPG.make_entity("drow/drow")
	
	print("Place monster: " + str(mon) + " @ " + str(pos))
	
	RPG.map.spawn(mon, pos)
	
func place_items(room):
	print("Placing items...")
	var x = RPG.roll(room.position.x+1, room.end.x-2)
	var y = RPG.roll(room.position.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	
	#var it = RPG.make_entity("potion/potion")
	var it = RPG.make_entity("longsword/longsword")
	
	print("Place item: " + str(it) + " @ " + str(pos))
	
	RPG.map.spawn(it, pos)