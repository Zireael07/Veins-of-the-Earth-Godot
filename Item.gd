extends Node

# class member variables go here, for example:
onready var ownr = get_parent()

export(String) var use_function = ''
export(bool) var indestructible

export(PoolIntArray) var damage = []

var inventory_slot

func use(entity):
	print("Using an item")
	
	if damage.size() > 0:
		print("wielding")
		# use the weapon's damage in place of the player's
		entity.fighter.damage = damage
		return
	
	if use_function.empty():
		RPG.broadcast("The " +ownr.name+ " cannot be used", RPG.COLOR_DARK_GREY)
		return
	if has_method(use_function):
		print("We have the function: " + str(use_function))
		var result = call(use_function, entity)
		if result != "OK":
			RPG.broadcast(result,RPG.COLOR_DARK_GREY)
			return
		if not indestructible:
			# fix
			RPG.inventory.remove_from_inventory(inventory_slot, ownr)
			ownr.remove()

func pickup(entity):
	RPG.broadcast(entity.get_name() + " picks up " + ownr.get_name())
	# TODO: this inventory isn't tied to any particular actor
	RPG.inventory.add_to_inventory(ownr)
	#pass

func drop(entity):
	RPG.broadcast(entity.get_name() + " drops " + ownr.get_name())
	# TODO: this inventory isn't tied to any particular actor
	assert inventory_slot != null
	RPG.inventory.remove_from_inventory(inventory_slot,ownr)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	ownr.item = self
	
	#pass

#-------------------------
# item use functions
func heal(entity):
	RPG.broadcast(entity.get_name() + " is healed!")
	var heal = RPG.roll(1,6)
	entity.fighter.hp += heal
	return "OK"


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func save():
	var data = {}
	data.use_function = self.use_function
	data.indestructible = self.indestructible
	return data

func restore(data):
	for key in data:
		if get(key)!=null:
			set(key, data[key])