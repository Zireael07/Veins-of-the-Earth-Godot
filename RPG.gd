extends Node

const GREETING = "Hello RPG!"

const TORCH_RADIUS = 4

onready var _db = preload("res://Database.tscn").instance()

var player
var map
var map_size

func make_entity( path ):
	return _db.spawn( path )
	
func roll(l,h):
	return int(round(rand_range(l,h)))