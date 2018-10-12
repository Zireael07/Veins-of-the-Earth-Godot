extends Node

onready var ownr = get_parent()

func _ready():
	ownr.ai = self
	
func take_turn():
	var target = RPG.player
	var distance = ownr.distance_to(target.get_map_position())
	print("AI taking turn")
	if distance <= RPG.TORCH_RADIUS:
		print("Player in torch radius")
		if distance <= 1:
			ownr.fighter.fight(target)
		else:
			print("AI making a move")
			ownr.step_to(target.get_map_position())

# dummies
func save():
	var data = {}
	return data

func restore(data):
	pass