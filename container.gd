extends Node

# class member variables go here, for example:
onready var ownr = get_parent()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	ownr.container = self
	
	# NPCs equip starting inventory
	if ownr != RPG.player:
		for o in ownr.container.get_objects():
			if o.item.equippable:
				o.item.use(ownr)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# Get an array of all inventory Objects
func get_objects():
	return self.get_children()

func get_equipped_objects():
	var eq = []
	var ob = get_objects()
	for o in ob:
		if o.item.equipped:
			eq.append(o)
	
	for o in eq:
		print(o.get_name())
	return eq
	
func get_equipped_in_slot(slot):
	var eq = get_equipped_objects()
	for o in eq:
		if o.item.equip_slot == slot:
			print(o.get_name())
			return o
	return null	
	
func add_to_inventory(item):
	# remove from world objects group
	if item.is_in_group('entity'):
		item.remove_from_group('entity')
	# add to inventory group
	if not item.is_in_group('inventory'):
		item.add_to_group('inventory')
	
	# clear equipped flags if any
	if item.item.equipped:
		item.item.equipped = false
		
	item.get_parent().remove_child(item)
	self.add_child(item)
	
	print("Added to inventory " + str(item.get_name()))
	
func remove_from_inventory(item):
	item.remove_from_group('inventory')
	item.add_to_group('entity')

	# fix dropping from worn inventory
	if item.item.equipped:
		item.item.equipped = false

	item.get_parent().remove_child(item)
	RPG.map.add_child(item)
	item.set_map_position(ownr.get_map_position())
	