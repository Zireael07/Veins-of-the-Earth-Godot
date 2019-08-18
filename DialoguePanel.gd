extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#initial_dialogue()
	pass

func initial_dialogue(entity):
	print(entity.get_parent().get_name())
	print(str(entity.conversations))
	if entity.conversations.size() < 1:
		print("Nothing to talk about")
		return
	
	# initial text
	$"VBoxContainer/Text".set_text(entity.conversations[0])
	
	# show both buttons
	$"VBoxContainer/Button1".show()
	$"VBoxContainer/Button2".show()

func quit_dialogue():
	hide()
	# unpause
	get_tree().set_pause(false)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			#print("Clicked")
			# if we're visible but buttons are hidden
			if is_visible() and not $"VBoxContainer/Button1".is_visible() and not $"VBoxContainer/Button2".is_visible():
				quit_dialogue()

var replies = { 1: "That's great!", 2: "If that's what you want..."}
func show_reply(id):
	$"VBoxContainer/Text".set_text(replies[id])
	# hide both buttons since no answer does anything yet
	$"VBoxContainer/Button1".hide()
	$"VBoxContainer/Button2".hide()


func _on_Button1_pressed():
	show_reply(1)
	


func _on_Button2_pressed():
	quit_dialogue()
	#show_reply(2)
