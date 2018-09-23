extends Button

# class member variables go here, for example:
var contents = []

func add_contents(what):
	contents.append(what)
	if not contents.empty():
		get_node('Sprite').set_texture(contents[0].get_icon())
		set_disabled(false)
	else:
		get_node('Sprite').set_texture(null)
		set_disabled(true)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	connect("mouse_entered", get_parent(), "_on_slot_mouse_enter", [self])
	connect("mouse_exited", get_parent(), "_on_slot_mouse_exit")
	
	#pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
