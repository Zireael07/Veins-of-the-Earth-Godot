extends Popup

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	
	# save?
	var file = File.new()
	var save_exists = file.file_exists(RPG.SAVEGAME_PATH)
	var button = get_node('Panel/VBoxContainer/Load')
	print("Persistent: " + str(OS.is_userfs_persistent()))
	print("User at: " + str(OS.get_user_data_dir()))
	print("Save exists: " + str(save_exists))
	
	
	get_tree().set_pause(false)
