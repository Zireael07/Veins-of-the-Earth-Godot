extends "entity.gd"

signal player_moved(me)
signal player_acted

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

func _ready():
	connect("player_moved", get_parent().get_node('FogMap'), '_on_player_pos_changed')
	connect("player_acted", get_parent(), '_on_player_acted')
	
	set_z_index(2)


func set_map_position(pos):
	.set_map_position(pos) 
	
	# signal
	emit_signal("player_moved", self)

func update_position(pos, direction):
	var data = .update_position(pos, direction)
	
	# signal
	emit_signal("player_moved", self)
	
	return data

func wait():
	emit_signal("player_acted")

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
		#if grid.is_floor(res[1]):
		# Check if unblocked
		var blocker = grid.is_cell_blocked(res[1])
		if not blocker:
			set_position(res[0]+Vector2(0,-8))
			emit_signal("player_acted")
		# Announce when we bump something
		else:
			if typeof(blocker) == TYPE_OBJECT:
				if blocker.fighter:
					fighter.fight(blocker)
				else:
					print("You punch the " + blocker.get_name() + " in the face!")
				
				emit_signal("player_acted")
			else:
				print( "Ow! You hit a wall!" )
				emit_signal("player_acted")

	# change level
	if Input.is_action_just_pressed("change_level"):
		if RPG.map.is_stairs(get_map_position()):
			print("Stairs at our location")
			RPG.map.next_level()
			RPG.broadcast("You descend a level")
		

	# other actions
	if Input.is_action_just_pressed("act_pickup"):
		var items = []
		for ob in RPG.map.get_entities_in_cell(get_map_position()):
			if ob.item:
				print("Item at our position")
				ob.item.pickup()
				
	if Input.is_action_just_pressed("act_drop"):
		RPG.inventory_menu.start(true)
		var items = yield(RPG.inventory_menu, 'items_selected')
		if items.empty():
			RPG.broadcast("action cancelled")
		else:
			for obj in items:
				obj.item.drop()
		
		emit_signal('player_acted')