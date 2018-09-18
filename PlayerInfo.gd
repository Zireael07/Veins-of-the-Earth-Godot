extends PanelContainer

# class member variables go here, for example:
#onready var powerlabel = get_node('VBoxContainer2/VBoxContainer/Power')
#onready var defenselabel = get_node('VBoxContainer2/VBoxContainer/Defense')

onready var hplabel = get_node("VBoxContainer2/HPBox/HP")
onready var hpbar = get_node("VBoxContainer2/HPBox/ProgressBar")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func hp_changed(current,full):
	hplabel.set_text(str(current) + " / " + str(full))
	hpbar.set_max(full)
	hpbar.set_value(current)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
