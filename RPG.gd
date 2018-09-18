extends Node

const GREETING = "Hello RPG!"

const TORCH_RADIUS = 4

onready var _db = preload("res://Database.tscn").instance()

# colors for message panel
const COLOR_WHITE = '#deeed6'
const COLOR_LIGHT_GREY = '#8595a1'
const COLOR_DARK_GREY = '#4e4a4e'
const COLOR_RED = '#d04648'
const COLOR_BROWN = '#854c30'
const COLOR_DARK_GREEN = '#346524'
const COLOR_GREEN = '#6daa2c'
const COLOR_YELLOW = '#dad45e'


var player
var map
var map_size
var game

func make_entity( path ):
	return _db.spawn( path )
	
func roll(l,h):
	return int(round(rand_range(l,h)))

func broadcast(message, color=COLOR_WHITE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.newline()