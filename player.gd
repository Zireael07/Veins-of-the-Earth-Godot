extends "entity.gd"

const DIRECTIONS = {
	"N":    Vector2(0,-1),
	"NE":   Vector2(1,-1),
	"E":    Vector2(1,0),
	"SE":   Vector2(1,1),
	"S":    Vector2(0,1),
	"SW":   Vector2(-1,1),
	"W":    Vector2(-1,0),
	"NW":   Vector2(-1,-1),
    }

func update_position(pos, direction):
	var grid_pos = grid.world_to_map(pos)

	var new_grid_pos = grid_pos + direction

	var target_pos = grid.map_to_world(new_grid_pos) + tile_offset
	
	# Print statements help to understand what's happening. We're using GDscript's string format operator % to convert
	# Vector2s to strings and integrate them to a sentence. The syntax is "... %s" % value / "... %s ... %s" % [value_1, value_2]
	print("Pos %s, dir %s" % [pos, direction])
	print("Grid pos, old: %s, new: %s" % [grid_pos, new_grid_pos])
	#print(target_pos)
	return [target_pos, new_grid_pos]


func _input(event):
	direction = Vector2()
	
#	if event is InputEventKey:
#		if event.pressed:
#			print(event.scancode)
	
	if Input.is_action_just_pressed("move_up"):
		direction = DIRECTIONS.N
		#direction.y = -1
	if Input.is_action_just_pressed("move_up_right"):
		direction = DIRECTIONS.NE
	if Input.is_action_just_pressed("move_right"):
		direction = DIRECTIONS.E
		#direction.x = 1
	if Input.is_action_just_pressed("move_down_right"):
		direction = DIRECTIONS.SE
	if Input.is_action_just_pressed("move_down"):
		direction = DIRECTIONS.S
		#direction.y = 1
	if Input.is_action_just_pressed("move_down_left"):
		direction = DIRECTIONS.SW
	if Input.is_action_just_pressed("move_left"):
		direction = DIRECTIONS.W
		#direction.x = -1
	if Input.is_action_just_pressed("move_up_left"):
		direction = DIRECTIONS.NW

	if direction != Vector2():
		# makes the move happen!
		var res = update_position(get_position(), direction)
		
		# Check for valid cell to step to
		if grid.is_floor(res[1]):
			set_position(res[0]+Vector2(0,-8))
		# Announce when we bump something
		else:
        	print( "Ow! You hit a wall!" )
