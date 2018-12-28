extends Button

# class member variables go here, for example:
var inven_root = null	
	
var contents = []

func add_contents(what):
	contents.append(what)
	what.item.inventory_slot = self
	
	update_slot()

func remove_contents(what):
	contents.remove(contents.find(what))
	what.item.inventory_slot = null
	update_slot()


func update_slot():
	if not contents.empty():
		get_node('Sprite').set_texture(contents[0].get_icon())
		set_disabled(false)
	else:
		get_node('Sprite').set_texture(null)
		set_disabled(true)


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	inven_root = get_tree().get_nodes_in_group("inventory")[0]
	
	connect("mouse_entered", get_parent(), "_on_slot_mouse_enter", [self])
	connect("mouse_exited", get_parent(), "_on_slot_mouse_exit")
	
	#pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_InventorySlot_pressed():
	# don't show if nothing in slot
	if contents.size() > 0:
		if get_node("MenuContainer").is_visible():
			get_node("MenuContainer").hide()
		else:
			# show the menu
			get_node("MenuContainer").show()
			


func _on_DropButton_pressed():
	var obj = contents[0]
	obj.item.drop(RPG.player)
	update_slot()
	
	get_node("MenuContainer").hide()
	
	# close the whole inventory
	inven_root.hide()
	# unpause
	get_tree().set_pause(false)


func _on_UseButton_pressed():
	var obj = contents[0]
	obj.item.use(RPG.player)
	update_slot()
	
	get_node("MenuContainer").hide()
	
	# close the whole inventory
	inven_root.hide()
	# unpause
	get_tree().set_pause(false)
	
	
	#pass # replace with function body
