extends TileMap

onready var map = get_parent()
#var map = null

func fill():
	for x in range(map.data.map.size()):
		for y in range(map.data.map[x].size()):
			#print("Filling fog for cell: " + str(x) + " " + str(y))
			set_cell(x,y,0)

func reveal(cells):
	for cell in cells:
		#print("Revealing cell " + str(cell))
		#print(str(get_cell(cell[0], cell[1])))
		#if get_cell(cell[0], cell[1]) != -1:
		if get_cellv(cell) != -1:
			set_cellv(cell,-1)
		#set_cell(cell[0], cell[1], -1)
		#print("Revealed cell " + str(cell))


func _ready():
	# we have to defer since otherwise we don't have access to map data
	call_deferred("fill") #fill()
	
func _on_player_pos_changed(player):
	# Torch (sight) radius
	var r = RPG.TORCH_RADIUS
	
	# Get FOV cells
	var cells = FOV_gen.calculate_fov(map.data.map, 1, player.get_map_position(), r)
	
	#print("Cells to reveal: " + str(cells))
	# Reveal cells
	reveal(cells)