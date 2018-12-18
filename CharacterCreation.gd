extends Control

# class member variables go here, for example:
onready var valscont = $"Panel/ValsContainer"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	pass

func roll():
	var stats_list = ["strength", "dexterity", "constitution", "intelligence", "wisdom", "charisma"]
	
	# roll dice for stats and show
	for i in range(stats_list.size()):
		var s = stats_list[i]
		RPG.player.get_node("Actor")[s] = RPG.roll_dice(3,6)
	
		valscont.get_child(i).set_text(str(RPG.player.get_node("Actor")[s]))


func _on_RerollButton_pressed():
	get_tree().set_pause(false)

	roll()


func _on_OKButton_pressed():
	hide()

	# recalc hp
	RPG.player.get_node("Actor")._set_max_hp(10)
	RPG.player.get_node("Actor").fill_hp()

func _on_TextEdit_text_entered(new_text):
#	print(new_text)
	RPG.player.set_name(new_text)
	
	# enable the OK button
	get_node("Panel/OKButton").set_disabled(false)
