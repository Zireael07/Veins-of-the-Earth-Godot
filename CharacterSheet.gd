extends Control

# class member variables go here, for example:
onready var valscont = $"Panel/ValsContainer"
onready var namelab = $"Panel/LabelName"
onready var melee = $"Panel/SkillsContainer/HBoxContainer/LabelVal"
onready var money = $"Panel/MoneyContainer"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	pass

func update_data():
	var stats_list = ["strength", "dexterity", "constitution", "intelligence", "wisdom", "charisma"]
	
	# roll dice for stats and show
	for i in range(stats_list.size()):
		var s = stats_list[i]
	
		valscont.get_child(i).set_text(str(RPG.player.get_node("Actor")[s]))
	
	namelab.set_text(str(RPG.player.get_name()))
	
	melee.set_text(str(RPG.player.get_node("Actor").melee))	
	
	var txt = ""
	for m in RPG.player.money:
        txt = txt + str(m[0]) + ": " + str(m[1]) + "\n"
	money.set_text(txt)


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
