extends HBoxContainer

# class member variables go here, for example:
onready var name_label = get_node('../../Control2/VBoxContainer/ItemName')

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# mouse support
func _on_slot_mouse_enter(slot):
	var name = '' if slot.contents.empty() else slot.contents[0].name
	var count = slot.contents.size()
	var nt = '' if count < 2 else str(count)+'x '
	name_label.set_text(nt + name)

func _on_slot_mouse_exit():
	name_label.set_text('')
