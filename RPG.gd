extends Node

const GREETING = "Hello RPG!"

onready var _db = preload("res://Database.tscn").instance()

func make_entity( path ):
	return _db.spawn( path )