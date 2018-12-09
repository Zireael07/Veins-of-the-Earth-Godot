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


func fill_hp():
	self.hp = self.max_hp

func fight(who):
	if who.fighter:
		# attack
		var melee = RPG.roll(1,100)
		if melee < 55:
			var dmg = RPG.roll(damage[0], damage[1])
			RPG.broadcast(ownr.name + " hits " + who.name + "!", RPG.COLOR_LIGHT_BLUE)
			who.fighter.take_damage(ownr, dmg) #self.power)
			who.add_splash(0, dmg)
		else:
			who.add_splash(1)
			RPG.broadcast(ownr.name + " misses " + who.name + "!")

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

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# roll dice for stats
	for s in ["strength", "dexterity", "constitution", "intelligence", "wisdom", "charisma"]:
		self[s] = RPG.roll_dice(3,6)
	
	
	ownr.fighter = self
	fill_hp()
	
	#pass

func broadcast_damage_taken(from, amount):
	var n = from.name
	var m = str(amount)
	var color = RPG.COLOR_DARK_GREY
	if ownr == RPG.player:
		color = RPG.COLOR_RED
	RPG.broadcast(n+ " hits " +ownr.name+ " for " +str(amount)+ " HP",color)

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
	return data

func restore(data):
	for key in data:
		if self.get(key)!=null:
			self.set(key, data[key])