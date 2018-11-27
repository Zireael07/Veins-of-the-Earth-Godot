extends PanelContainer

# class member variables go here, for example:
#onready var powerlabel = get_node('VBoxContainer2/VBoxContainer/Power')
#onready var defenselabel = get_node('VBoxContainer2/VBoxContainer/Defense')

onready var hplabel = get_node("VBoxContainer2/HPBox/HP")
onready var hpbar = get_node("VBoxContainer2/HPBox/ProgressBar")
onready var coords = get_node("VBoxContainer2/VBoxContainer/Coords")
onready var npclabel = get_node("VBoxContainer2/VBoxContainer/NPCLabel")
onready var hplabel_npc = get_node("VBoxContainer2/VBoxContainer/HPBoxNPC/HP2")
onready var hpbar_npc = get_node("VBoxContainer2/VBoxContainer/HPBoxNPC/ProgressBar2")

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
	var entities_text = RPG.map.get_entities_in_cell_readable(cell)
	
	npclabel.set_text(str(entities_text))
	
	var entities = RPG.map.get_entities_in_cell(cell)
	# if we have an entity that is an actor, display hp
	if entities.size() > 0 and entities[0].fighter != null:
		$"VBoxContainer2/VBoxContainer/HPBoxNPC".show()
		hplabel_npc.set_text("HP: " + str(entities[0].fighter.max_hp) + " / "+str(entities[0].fighter.hp))
		hpbar_npc.set_max(entities[0].fighter.max_hp)
		hpbar_npc.set_value(entities[0].fighter.hp)
	else:
		$"VBoxContainer2/VBoxContainer/HPBoxNPC".hide()
	
