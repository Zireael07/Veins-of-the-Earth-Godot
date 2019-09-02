extends Control

# Declare member variables here. Examples:
onready var item_box = get_node("PlayerContainer")
onready var shop_box = get_node("HBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start():	
	clear_items()
	fill_from_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if (event is InputEventKey):
		if event.scancode == KEY_ESCAPE and event.pressed:
			print("Esc pressed")
			
			if not is_visible():
				print("Pausing")
				# prevents accidentally doing other stuff
				get_tree().set_pause(true)
				show()
			else:
				print("Unpausing")
				get_tree().set_pause(false)
				hide()

func clear_items():
	for i in range(item_box.get_child_count()):
		item_box.get_child(i).queue_free()
		print("Clear item" + str(i))
				
func fill_from_inventory():
	# Get inventory objects
	#var items = RPG.inventory.get_objects()
	var items = RPG.player.container.get_objects()
	
	for obj in items:
		# instanciate & add
		var ob = preload('res://ItemListButton.tscn').instance()
		item_box.add_child(ob)
		# assign item to button
		ob.ownr = obj
		# connect button toggle
		ob.connect("toggled", self, "_on_ItemButton_toggled", [ob])
		
func _on_ItemButton_toggled(pressed, ob):
	print("Item pressed")
	if ob.get_parent().get_name() == "PlayerContainer":
		# reparent
		ob.get_parent().remove_child(ob)
		shop_box.add_child(ob)
	else:		
		# reparent
		ob.get_parent().remove_child(ob)
		item_box.add_child(ob)