extends Node

const GREETING = "Hello RPG!"

const TORCH_RADIUS = 4

onready var _db = preload("res://Database.tscn").instance()
const SAVEGAME_PATH = "user://game.sav"
var restore_game = false

# colors for message panel
const COLOR_WHITE = '#ffffff' #deeed6'
const COLOR_RED = '#d04648'
const COLOR_BROWN = '#854c30'
const COLOR_DARK_GREEN = '#346524'
const COLOR_GREEN = '#6daa2c'
const COLOR_YELLOW = '#dad45e'
# from libtcod
const COLOR_LIGHT_BLUE = "#73b9ff" #7373ff"
const COLOR_DARK_GREY = "5f5f5f"   #'#4e4a4e' #muddy gray
const COLOR_LIGHT_GREY = "9f9f9f" #'#8595a1'


var player
var map
var map_size
var game
var inventory
# for the drop panel
var inventory_menu

func make_entity( path ):
	return _db.spawn( path )
	
func roll(l,h):
	return int(round(rand_range(l,h)))

func broadcast(message, color=COLOR_WHITE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.newline()