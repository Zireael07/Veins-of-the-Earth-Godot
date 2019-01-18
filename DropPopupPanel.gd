extends Popup


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

signal items_selected(items)	# emits an array of selected items

# class member variables go here, for example:
onready var item_box = get_node('frame/contents/ScrollContainer/Items')



var multi_select = false

func start(multi=false): #,header='', footer=''):
	# set mode
	self.multi_select = multi
	# set header/footer text
	#get_node('frame/Header').set_text(header)
	#get_node('frame/Footer').set_text(footer)
	# refresh contents
	clear_items()
	fill_from_inventory()
	# pause and show
	show()
	get_tree().set_pause(true)
	

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

func done():
	# unpause game and hide menu
	hide()
	get_tree().set_pause(false)

	

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	RPG.inventory_menu = self
	set_process_input(true)

func _input(event):
	var CANCEL = event.is_action_pressed("ui_cancel")
	var CONFIRM = event.is_action_pressed("ui_accept")

	if CANCEL:
		done()

		emit_signal('items_selected', []) # signal no items selected

	
	if CONFIRM:
		done()

		var items = []
		for itm in item_box.get_children():
			if itm.is_pressed():
				items.append(itm.ownr)

		emit_signal('items_selected', items)

func _on_ItemButton_toggled( pressed, who ):
	if pressed and not multi_select:
		for node in item_box.get_children():
			if node != who:
				node.set_pressed(false)



