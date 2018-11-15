extends Node2D

# class member variables go here, for example:
var type = 0

var DAMAGE = 0
var SHIELD = 1

var dmg = null

func _ready():
	var shield_tex = preload("res://assets/splash_shield.png")
	var splash_tex = preload("res://assets/splash_gray.png")
	
	
	if type == SHIELD:
		$"Sprite".set_texture(shield_tex)
		# hide label because not necessary
		$"dmg_label".set_visible(false)
	elif type == DAMAGE:
		$"Sprite".set_texture(splash_tex)
		$"Sprite".set_modulate(Color(1,0,0)) # red
		if dmg:
			$"dmg_label".set_text(str(dmg))
		else:
			$"dmg_label".set_visible(false)
	
	# Called when the node is added to the scene for the first time.
	# Initialization here

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	#print("Timed out")
	queue_free()
