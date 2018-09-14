extends Node

# class member variables go here, for example:
export(int) var power = 1
export(int) var defense = 1

export(int) var max_hp = 5
var hp = 5 setget _set_hp


func fill_hp():
	self.hp = self.max_hp

func fight(who):
	if who.fighter:
		who.fighter.take_damage(self.power)

func take_damage(amount):
	self.hp -= amount
	print(get_parent().get_name() + " takes " + str(amount) + " damage!")

func _set_hp(value):
	hp = value

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	owner.fighter = self
	
	#pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
