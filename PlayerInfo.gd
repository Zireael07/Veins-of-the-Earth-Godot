extends PanelContainer

# class member variables go here, for example:

onready var hplabel = get_node("VBoxContainer2/HPBox/HP")
onready var hpbar = get_node("VBoxContainer2/HPBox/ProgressBar")

onready var hp_torso = get_node("VBoxContainer2/HPBox/HP2")
onready var hp_torso_bar = get_node("VBoxContainer2/HPBox/ProgressBar2")

onready var hp_arm = get_node("VBoxContainer2/HPBox2/HP3")
onready var hp_arm_bar = get_node("VBoxContainer2/HPBox2/ProgressBar3")

onready var hp_arm2 = get_node("VBoxContainer2/HPBox2/HP4")
onready var hp_arm2_bar = get_node("VBoxContainer2/HPBox2/ProgressBar4")

onready var hp_leg = get_node("VBoxContainer2/HPBox3/HP3")
onready var hp_leg_bar = get_node("VBoxContainer2/HPBox3/ProgressBar3")

onready var hp_leg2 = get_node("VBoxContainer2/HPBox3/HP4")
onready var hp_leg2_bar = get_node("VBoxContainer2/HPBox3/ProgressBar4")

onready var coords = get_node("VBoxContainer2/VBoxContainer/Coords")
onready var npclabel = get_node("VBoxContainer2/VBoxContainer/NPCLabel")
onready var hplabel_npc = get_node("VBoxContainer2/VBoxContainer/HPBoxNPC/HP2")
onready var hpbar_npc = get_node("VBoxContainer2/VBoxContainer/HPBoxNPC/ProgressBar2")

var part_to_elem = {}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	part_to_elem = { "head":[hplabel, hpbar], "torso":[hp_torso, hp_torso_bar],
	"arm":[hp_arm, hp_arm_bar], "arm2":[hp_arm2, hp_arm2_bar],
	"leg":[hp_leg, hp_leg_bar], "leg2":[hp_leg2, hp_leg2_bar]
 }
	
	#pass



func hp_changed(current,full, part):
	var elems = part_to_elem[part]
	elems[0].set_text(str(current) + " / " + str(full))
	elems[1].set_max(full)
	elems[1].set_value(current)
	
	#hplabel.set_text(str(current) + " / " + str(full))
	#hpbar.set_max(full)
	#hpbar.set_value(current)

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
		hplabel_npc.set_text("HP: " + str(entities[0].fighter.hp) + " / "+str(entities[0].fighter.max_hp))
		hpbar_npc.set_max(entities[0].fighter.max_hp)
		hpbar_npc.set_value(entities[0].fighter.hp)
	else:
		$"VBoxContainer2/VBoxContainer/HPBoxNPC".hide()
	
