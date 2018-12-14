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


func _on_TextEdit_text_entered(new_text):
#	print(new_text)
	RPG.player.set_name(new_text)
