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
var calendar #small c

func make_entity( path ):
#	print("Making entity... " + str(path))
	return _db.spawn( path )
	
func roll(l,h):
	return int(round(rand_range(l,h)))

func roll_dice(n, d):
	var res = 0
	for i in range(n):
		res += int(round(rand_range(1,d)))
		
	return res


func broadcast(message, color=COLOR_WHITE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.newline()
			
# calendar
## Taken from Incursion
##"Reprise", "Icemelt", "Turnleaf", "Blossom" --spring/summer
## "Suntide", "Harvest", "Leafdry", "Softwind", --summer/fall
## "Thincold", "Deepcold", "Midwint", "Arvester", --fall/winter


class Calendar:
	var calendar = []
	var days = 0
	var start_year
	var start_day
	var start_hour
	var turn
	
	var MINUTE = 60/10
	var HOUR = MINUTE*60
	var DAY = HOUR*24
	var YEAR = DAY*365

	
	var calendar_data = [
	[30, "Arvester"],
	[1, "Midwinter"],
	[30, "Reprise"],
	[30, "Icemelt"],
	[30, "Turnleaf"], # April
	[1, "Greengrass"],
	[30, "Blossom"], # May
	[30, "Suntide"], # June
	[30, "Harvest"],
	[1, "Midsummer"],
	[30, "Leafdry"], # August
	[30, "Softwind"],
	[1, "Highharvestide"],
	[30, "Thincold"],
	[30, "Deepcold"], # November
	[1, "Year Feast"],
	[30, "Midwint"] #December
  ]

	
	
	func _init(year=1370, day=1, hour=8):
		for m in calendar_data:
			days = days + m[0]

		start_year = year
		start_day = day
		start_hour = hour

		turn = 0

	func get_time(tm):
		var turn = tm + start_hour * HOUR
		var _min = int(floor((turn % DAY) / MINUTE))
		var hour = int(floor(_min / 60))
		_min = int(floor(_min % 60))
		return [hour, _min]

	func get_day(tm):
		var turn = tm + start_hour * HOUR
		var d = int(floor(turn / DAY) + (start_day))
		var y = int(floor(d / 365))
		d = int(floor(d % 365))
		return [d, start_year + y]

	func get_month_num(day):
		var i = calendar_data.size()

		while i > 0 and (day < days):
			i -= 1

		return i

	func get_month_name(day):
		var month = get_month_num(day)
		return calendar_data[month][1]

	func get_time_date(turn):
		var data = get_day(turn)
		var month = get_month_name(data[0])
		var tm = get_time(turn)
		return "Today is %s %s of %s DR. The time is %d:%d" % [data[0], month, data[1], tm[0], tm[1]]