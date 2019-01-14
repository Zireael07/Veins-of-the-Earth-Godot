extends Control

# class member variables go here, for example:
onready var messagebox = get_node('frame/right/Panel/MessageBox')
onready var playerinfo = get_node('frame/left/PlayerInfo')
onready var inventory = get_node('frame/right/map/InventoryPanel')
onready var death_panel = get_node('DeathPopup')
onready var dialogue_panel = get_node('frame/right/map/DialoguePanel')
onready var character_sheet = get_node('CharacterSheet')

var labels = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	# prevent quitting without saving
	get_tree().set_auto_accept_quit(false)
	
	RPG.game = self
	messagebox.set_scroll_follow(true)

	if RPG.restore_game:
		restore_game()
	else:
		new_game()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func new_game():
	# just call
	RPG.map.new_game()
	
	# show welcome
	get_node("WelcomePopup").popup()

# save on quit
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if not RPG.player.dead:
			var saved = save_game()
			if saved != OK:
				print('SAVE GAME RETURNED ERROR '+str(saved))
		else:
			print("Skipping save, player dead")
			
		get_tree().quit()

# Save Game Mother Function
func save_game():
	print("Saving game...")
	
	# create a new file object to work with
	var file = File.new()
	var opened = file.open(RPG.SAVEGAME_PATH, File.WRITE)
	
	# Alert and return error if file can't be opened
	if not opened == OK:
		OS.alert("Unable to access file " + RPG.SAVEGAME_PATH)
		return opened

	# Gather data to save
	var data = {}
	
	# Map data: Datamap and Fogmap
	data.map = RPG.map.save()
	
	# Player object data
	data.player = RPG.player.save()

	# non-player objects
	data.objects = []
	data.inventory = []
	for node in get_tree().get_nodes_in_group('entity'):
		# because we saved player data earlier
		if node != RPG.player:
			data.objects.append(node.save())
	
	for node in get_tree().get_nodes_in_group('inventory'):
		data.inventory.append(node.save())
		
	
	# Store data and close file
	file.store_line(to_json(data))
	file.close()
	# Return OK if all goes well
	return opened

# Restore Game Mother Function
func restore_game():
	print("Loading game...")
	
	# create a new file object to work with
	var file = File.new()
	
	# return error if file not found
	if not file.file_exists(RPG.SAVEGAME_PATH):
		OS.alert("No file found at " + RPG.SAVEGAME_PATH)
		return ERR_FILE_NOT_FOUND

	var opened = file.open(RPG.SAVEGAME_PATH, File.READ)
	
	# Alert and return error if file can't be opened
	if not opened == OK:
		OS.alert("Unable to access file " + RPG.SAVEGAME_PATH)
		return opened

	# Dictionary to store file data
	var data = {}
	
	# Parse data from json file
	data = parse_json(file.get_as_text())
	
	################
	# Restore game from data
	################
	
	# Map Data
	if 'map' in data:
		RPG.map.restore(data.map)
	
#	# Global Playerdata
#	if 'player_data' in data:
#		for key in data.player_data.keys():
	
#	# Player data
	if 'player' in data:
		var start_pos = Vector2(data.player.x, data.player.y)
		RPG.map.spawn_player(start_pos)
		RPG.player.restore(data.player)

	# Object data
	if 'objects' in data:
		for entry in data.objects:
			var ob = RPG.map.restore_object(entry)
			var pos = Vector2(entry.x,entry.y)
#			RPG.map.spawn(ob,pos)

	# Inventory data
	if 'inventory' in data:
		for entry in data.inventory:
			var ob = RPG.map.restore_object(entry)
			print(ob.item != null)
			ob.item.pickup(RPG.player)
	
	
	# close file and return status
	file.close()
	
	return opened


func _on_QuitButton_pressed():
	print("Quit pressed")
	get_node("frame/right/map/Panel").hide()
	if not RPG.player.dead:
		save_game()
	else:
		print("Skipping save, player dead")
	get_tree().quit()
	
	
	#pass # replace with function body

func _input(event):
	if (event is InputEventKey):
		if event.scancode == KEY_ESCAPE and event.pressed:
			print("Esc pressed")
			if get_node("WelcomePopup").is_visible():
				get_node("WelcomePopup").hide()
				get_node("CharacterCreation").roll()
				get_node("CharacterCreation").show()
				return
			
			
			if get_node("frame/right/map/Panel").is_visible():
				get_node("frame/right/map/Panel").hide()
			else:
				get_node("frame/right/map/Panel").show()
		
	if Input.is_action_pressed("toggle_labels"):
		# toggle
		labels = not labels
		
		var entities = get_tree().get_nodes_in_group('entity')
		for e in entities:
			if labels:
				e.get_node("Label").show()
			else:
				e.get_node("Label").hide()