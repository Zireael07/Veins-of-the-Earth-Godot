extends Node

# class member variables go here, for example:
onready var ownr = get_parent()

export(String) var use_function = ''
export(bool) var indestructible
# equipment
export(bool) var equippable
var equipped = false
export(String) var equip_slot = ''


export(PoolIntArray) var damage = []
export(int) var armor = 0

var inventory_slot

# TODO: calculate?
# 1 sp = 10 cp
# 1 gp = 20 sp = 200 cp
# 1 pp = 10 gp = 200 sp = 2000 cp

export(int) var price = 1 # in copper because there are items worth less than 1 sp

func use(entity):
	print("Using an item")
	
	if equippable:
#		print("Equippable")
		if not equipped:
			# check for equipped
			var worn = entity.container.get_equipped_in_slot(equip_slot) 
			if worn != null:
				print("Already wearing item in slot " + str(equip_slot) + " " + str(worn.read_name) + "!")
				# take off the item in slot
				RPG.broadcast(entity.read_name + " took off " + worn.read_name, RPG.COLOR_WHITE)
				worn.item.equipped = false
				
				if entity == RPG.player:
					# GUI update
					RPG.inventory.move_to_inventory(worn.item.equip_slot, worn)
					
				# prevent falling through
				#return
				
			#else:
			RPG.broadcast(entity.read_name + " equipped " + ownr.read_name, RPG.COLOR_WHITE)
			equipped = true
			
			if entity == RPG.player:
				# GUI update
				RPG.inventory.move_to_equipped(inventory_slot, equip_slot, ownr)
				
			if equip_slot == "MAIN_HAND" and damage.size() > 0:
				#print("Using the sword's damage")
				# use the weapon's damage in place of the player's
				entity.fighter.damage = damage
				return
			else:
				# prevent falling through
				return
				
				
	if use_function.empty():
		RPG.broadcast("The " +ownr.read_name+ " cannot be used", RPG.COLOR_DARK_GREY)
		return
	if has_method(use_function):
		print("We have the function: " + str(use_function))
		var result = call(use_function, entity)
		if result != "OK":
			RPG.broadcast(result,RPG.COLOR_DARK_GREY)
			return
		if not indestructible:
			# fix
			entity.container.remove_from_inventory(ownr)
			if entity == RPG.player:
				RPG.inventory.remove_from_inventory(inventory_slot, ownr)
			ownr.remove()

func pickup(entity):
	# fix
	ownr.set_visible(false)
	ownr.set_map_position(entity.get_map_position())
	
	
	RPG.broadcast(entity.read_name + " picks up " + ownr.read_name)
	entity.container.add_to_inventory(ownr)

	if entity == RPG.player:
		RPG.inventory.add_to_inventory(ownr)
	#pass

func drop(entity):
	RPG.broadcast(entity.read_name + " drops " + ownr.read_name)
	
	# fix
	ownr.set_visible(true)
	ownr.set_map_position(entity.get_map_position())
	
	entity.container.remove_from_inventory(ownr)
	
	if entity == RPG.player:
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
	RPG.broadcast(entity.read_name + " is healed!")
	var heal = RPG.roll(1,6)
	entity.fighter.hp += heal
	return "OK"

func eat(entity):
	if 'nutrition' in entity and entity.nutrition < 500:
		RPG.broadcast("You ate your food", RPG.COLOR_GREEN)
		entity.nutrition = entity.nutrition + 150
		# update HUD
		RPG.game.playerinfo.get_node("VBoxContainer2/NutritionBar").set_value(entity.nutrition)
		return "OK"
	else:
		return "You're full, you can't eat any more"
		#RPG.broadcast("You're full, you can't eat any more", RPG.COLOR_YELLOW)
		#return "OK"

func drink(entity):
	if 'thirst' in entity and entity.thirst < 300:
		RPG.broadcast("You drank from the flask", RPG.COLOR_LIGHT_BLUE)
		entity.thirst = entity.thirst + 150
		# update HUD
		RPG.game.playerinfo.get_node("VBoxContainer2/ThirstBar").set_value(entity.thirst)
		return "OK"
	else:
		return "You're full, you can't drink any more"
		#RPG.broadcast("You're full, you can't drink any more", RPG.COLOR_YELLOW)
		#return "OK"


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