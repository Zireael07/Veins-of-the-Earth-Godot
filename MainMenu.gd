extends Control

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
