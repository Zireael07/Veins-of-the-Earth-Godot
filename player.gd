extends "entity.gd"

var nutrition = 500
var thirst = 300
var money = []

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
	connect("player_moved", get_parent(), '_on_player_pos_changed')
	connect("player_acted", get_parent(), '_on_player_acted')
	
	set_z_index(2)

	# money
	money = [ ["bronze", 0],
			  ["silver", 100],
			  ["gold", 0],
			  ["platinum", 0]]

func set_map_position(pos):
	.set_map_position(pos) 
	
	# signal
	emit_signal("player_moved", self)

func update_position(pos, direction):
	var data = .update_position(pos, direction)
	
	# signal
	emit_signal("player_moved", self)
	
	return data

func kill():
	print("Player is killed!")
	# prevents accidentally doing other stuff
	get_tree().set_pause(true)
	
	RPG.game.death_panel.show()

func wait():
	emit_signal("player_acted")

func step_to(cell):
	.step_to(cell)
	emit_signal("player_moved", self)

	
func act():
	print("Player act")
	nutrition -= 1
	thirst -= 1

	# starve/thirst
	if nutrition <= 0 or thirst <= 0:
	   fighter.take_damage(self, 1)
	
	# update HUD
	RPG.game.playerinfo.get_node("VBoxContainer2/NutritionBar").set_value(nutrition)
	RPG.game.playerinfo.get_node("VBoxContainer2/ThirstBar").set_value(thirst)
	
	# display time
	RPG.broadcast(RPG.calendar.get_time_date(RPG.calendar.turn))

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
		print("Should change level")
		if RPG.map.is_stairs(get_map_position()):
			print("Stairs at our location")
			RPG.map.next_level()
			RPG.broadcast("You descend a level")
		

	# other actions
	if Input.is_action_just_pressed("act_pickup"):
		var items = []
		for ob in RPG.map.get_entities_in_cell(get_map_position()):
			if ob.item:
				#print("Item at our position")
				ob.item.pickup(self)
				
	if Input.is_action_just_pressed("act_drop"):
		RPG.inventory_menu.start(true)
		var items = yield(RPG.inventory_menu, 'items_selected')
		if items.empty():
			RPG.broadcast("action cancelled")
		else:
			for obj in items:
				obj.item.drop(self)
		
		emit_signal('player_acted')
		
	if Input.is_action_just_pressed("help"):
		RPG.game.get_node("HelpPopup").popup()
		
	if Input.is_action_just_pressed("character_sheet"):
		if RPG.game.character_sheet.is_visible():
			RPG.game.character_sheet.hide()
		else:
			RPG.game.character_sheet.update_data()
			RPG.game.character_sheet.show()
			
# money
func add_money(values):
	print(str(values))
	for v in values:
		for m in money:
			if v[0] == m[0]:
				m[1] += v[1]
				print("Incrementing " + str(m[0]) + " by " + str(v[1]))
				break

func remove_money(values):
	print(str(values))
	for v in values:
		for m in money:
			if v[0] == m[0]:
				m[1] -= v[1]
				print("Decrementing " + str(m[0]) + " by " + str(v[1]))
				break