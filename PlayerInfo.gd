extends PanelContainer

# class member variables go here, for example:
#onready var powerlabel = get_node('VBoxContainer2/VBoxContainer/Power')
#onready var defenselabel = get_node('VBoxContainer2/VBoxContainer/Defense')

onready var hplabel = get_node("VBoxContainer2/HPBox/HP")
onready var hpbar = get_node("VBoxContainer2/HPBox/ProgressBar")
onready var coords = get_node("VBoxContainer2/VBoxContainer/Coords")
onready var npclabel = get_node("VBoxContainer2/VBoxContainer/NPCLabel")

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


func _on_Node2D_cell_hover(cell):
	coords.set_text(str(cell))
	var entities = RPG.map.get_entities_in_cell_readable(cell)
	
	npclabel.set_text(str(entities))
