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

# these work regardless of turns
func _input(event):
	if Input.is_action_pressed("inventory"):
		if not is_visible():
			print("Pausing")
			# prevents accidentally doing other stuff
			get_tree().set_pause(true)
			show()
		else:
			print("Unpausing")
			get_tree().set_pause(false)
			hide()