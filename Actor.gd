extends Node

# class member variables go here, for example:
export(int) var power = 1
export(int) var defense = 1

signal hp_changed(current,full)

export(int) var max_hp = 5 setget _set_max_hp
var hp = 5 setget _set_hp


func fill_hp():
	self.hp = self.max_hp

func fight(who):
	if who.fighter:
		who.fighter.take_damage(self.power)

func take_damage(amount):
	self.hp -= amount
	print(get_parent().get_name() + " takes " + str(amount) + " damage!")

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
	
	owner.fighter = self
	fill_hp()
	
	#pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
