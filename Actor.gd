extends Node

# class member variables go here, for example:
	
onready var ownr = get_parent()

#export(int) var power = 1
var damage = [1,6]
export(int) var defense = 1

signal hp_changed(current,full)

export(int) var max_hp = 10 setget _set_max_hp
var hp = 10 setget _set_hp

# stats
var strength = 8
var dexterity = 8
var constitution = 8
var intelligence = 8
var wisdom = 8
var charisma = 8

var base_armor = 0 #setget _get_armor # damage reduction

export(int) var faction_id = 1
enum faction { PLAYER = 0, ENEMY = 1, NEUTRAL = 2}


func get_armor():
	var armor = base_armor
	var object_bonuses = []

	for o in ownr.container.get_equipped_objects():
		if o.item.armor > 0:
			object_bonuses.append(o.item.armor)
			
	for v in object_bonuses:
		armor += v
		
#	print("Armor: " + str(armor))
	return armor


func fill_hp():
	self.hp = self.max_hp

func fight(who):
	# paranoia
	if not who.fighter:
		return
		
	var react = faction_reaction[int(who.fighter.faction_id)]
	var self_react = faction_reaction[int(faction_id)]
#	print(who.get_name() + " reaction: " + str(react))
	if (RPG.player == self.ownr and react < -50) or self_react < -50: # hack for now
		# attack
		var melee = RPG.roll(1,100)
		if melee < 55:
			var dmg = RPG.roll(damage[0], damage[1])
			var mod = int(floor((strength - 10)/2))
			RPG.broadcast(ownr.name + " hits " + who.name + "!", RPG.COLOR_LIGHT_BLUE)
			who.fighter.take_damage(ownr, max(0,dmg + mod - who.fighter.get_armor())) #self.power)
			who.add_splash(0, max(0,dmg + mod - who.fighter.get_armor()))
		else:
			who.add_splash(1)
			RPG.broadcast(ownr.name + " misses " + who.name + "!")
	else:
		print("Not a hostile")
		if RPG.player == self.ownr and react == 0:
			# dialogue
			RPG.game.dialogue_panel.initial_dialogue()
			RPG.game.dialogue_panel.show()
			# prevents accidentally doing other stuff
			get_tree().set_pause(true)
		
func take_damage(from, amount):
	#print(get_parent().get_name() + " takes " + str(amount) + " damage!")
	broadcast_damage_taken(from,amount)
	self.hp -= amount

func die():
	get_parent().kill()

func _set_hp(value):
	hp = value
	emit_signal('hp_changed', hp, self.max_hp)
	if hp <= 0:
		die()

func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

# this is where we apply stat bonus (after we have it)
func set_real_max_hp(what):
#	print(get_parent().get_name() + " bonus hp: " + str(int(floor(constitution - 10)/2)))
	max_hp = what + int(floor(constitution - 10)/2)
	print(get_parent().get_name() + " " + str(max_hp))
	emit_signal('hp_changed', self.hp, self.max_hp)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	
	# roll dice for stats
	for s in ["strength", "dexterity", "constitution", "intelligence", "wisdom", "charisma"]:
		self[s] = RPG.roll_dice(3,6)
	
	
	ownr.fighter = self
	set_real_max_hp(self.max_hp)
	fill_hp()
	
	# set applicable marker color
	ownr.get_node("marker").set_modulate(get_marker_color())
	
	#pass

func broadcast_damage_taken(from, amount):
	var n = from.name
	var m = str(amount)
	var color = RPG.COLOR_DARK_GREY
	if ownr == RPG.player:
		color = RPG.COLOR_RED
	RPG.broadcast(n+ " hits " +ownr.name+ " for " +str(amount)+ " HP",color)

var faction_reaction = { faction.PLAYER: 100, faction.ENEMY: -100, faction.NEUTRAL: 0 }
func get_marker_color():
	var react = faction_reaction[faction_id]
	print(str(react))
	
	if react < -50:
		return Color(1.0, 0, 0) #"red"
	elif react < 0:
		return "orange"
	elif react == 0:
		return Color(1.0, 1.0, 0.0) #"yellow"
	elif react > 50:
		return Color(0, 1.0, 1.0)  #"cyan"
	elif react > 0:
		return "blue"

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func save():
	var data = {}
	data.damage = self.damage
	data.defense = self.defense
	data.max_hp = self.max_hp
	data.hp = self.hp
	data.strength = self.strength
	data.dexterity = self.dexterity
	data.constitution = self.constitution
	data.intelligence = self.intelligence
	data.wisdom = self.wisdom
	data.charisma = self.charisma
	data.faction_id = self.faction_id
	return data

func restore(data):
	for key in data:
		if self.get(key)!=null:
			self.set(key, data[key])