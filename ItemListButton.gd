extends Button

var ownr = null setget _set_owner



func _set_owner(what):
	ownr = what
	set_text(ownr.read_name)
	set_button_icon(ownr.get_icon())

# for shop screen
func set_price(what):
	set_text(get_text() + " (" + str(what) + " cp)")