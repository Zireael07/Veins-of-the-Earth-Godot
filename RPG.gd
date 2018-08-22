extends Node

const GREETING = "Hello RPG!"

const TORCH_RADIUS = 4

onready var _db = preload("res://Database.tscn").instance()

func make_entity( path ):
	return _db.spawn( path )