extends Node2D

# class member variables go here, for example:
var map_hovered = false
var cell_hovered = null setget _set_cell_hovered

var map

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	map = get_node("TileMap")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Viewport_gui_input(ev):
	# place the cursor
	if ev is InputEventMouseMotion:
		if !self.map_hovered:
			self.map_hovered = true
			$"TileMap/Cursor".visible = true
		var map_cell = map.world_to_map( get_global_mouse_position() )
		if map_cell != self.cell_hovered:
			self.cell_hovered = map_cell
	


func _on_Viewport_mouse_exited():
	self.map_hovered = false
	$"TileMap/Cursor".visible = false
	self.cell_hovered = null

func _set_cell_hovered( what ):
	cell_hovered = what
	if cell_hovered:
		$"TileMap/Cursor".position = map.map_to_world( cell_hovered )