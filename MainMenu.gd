extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	# check for save file
	var file = File.new()
	var save_exists = file.file_exists(RPG.SAVEGAME_PATH)
	var button = get_node('Panel/VBoxContainer/Load')
	#print("Save exists: " + str(save_exists))
	button.set_disabled(!save_exists)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if (event is InputEventKey):
		#print("Key pressed: " + char(event.scancode))
		if event.scancode == KEY_S:
			print("S key pressed")
			get_tree().change_scene("res://Game.tscn")
			
		if event.scancode == KEY_Q:
			print("Q key pressed")
			get_tree().quit()


func _on_New_game_pressed():
	print("New game pressed")
	get_tree().change_scene("res://Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
	#pass # replace with function body


func _on_Load_pressed():
	RPG.restore_game = true
	get_tree().change_scene("res://Game.tscn")
	
	
	#pass # replace with function body
