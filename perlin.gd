extends Node

# class member variables go here, for example:
var table = [151,160,137,91,90,15,
   131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
   190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
   88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
   77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
   102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
   135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
   5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
   223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
   129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
   251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
   49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
   138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180]


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here

	var noise = noise_3d(3.14, 42, 7)
	print("Noise for (3.14 42 7) is " + str(noise))


# code based on https://github.com/purple-ice/perlin-noise-py
# ----------------------------------------------

func fade(t):
	return pow(t,3) * (t * (t * 6 - 15) + 10)


# 2D

func grad_2d(hashvalue, x, y):
	var cas = hashvalue & 0x7
	if cas == 0x0: return      y
	if cas == 0x1: return  x + y
	if cas == 0x2: return      x
	if cas == 0x3: return  x - y
	if cas == 0x4: return     -y
	if cas == 0x5: return -x - y
	if cas == 0x6: return     -x
	if cas == 0x7: return -x + y

func noise_2d(x, y):
	var xi = int(floor(x)) & 0xFF
	var yi = int(floor(y)) & 0xFF
	var xf = x - int(floor(x))
	var yf = y - int(floor(y))
	var u = fade(xf)
	var v = fade(yf)

	var aa = table[table[xi    ] + yi    ]
	var ba = table[table[xi + 1] + yi    ]
	var ab = table[table[xi    ] + yi + 1]
	var bb = table[table[xi + 1] + yi + 1]

	var y1 = lerp(
		grad_2d(aa, xf    , yf    ),
		grad_2d(ba, xf - 1, yf    ),
		u
	)

	var y2 = lerp(
		grad_2d(ab, xf    , yf - 1),
		grad_2d(bb, xf - 1, yf - 1),
		u
	)

	return lerp(y1, y2, v)

# ---------------------------	
# 3d
func grad_3d(hashvalue, x, y, z):
	var cas = hashvalue & 0xF
	if cas == 0x0: return  x + y
	if cas == 0x1: return -x + y
	if cas == 0x2: return  x - y
	if cas == 0x3: return -x - y
	if cas == 0x4: return  x + z
	if cas == 0x5: return -x + z
	if cas == 0x6: return  x - z
	if cas == 0x7: return -x - z
	if cas == 0x8: return  y + z
	if cas == 0x9: return -y + z
	if cas == 0xA: return  y - z
	if cas == 0xB: return -y - z
	if cas == 0xC: return  y + x
	if cas == 0xD: return -y + z
	if cas == 0xE: return  y - x
	if cas == 0xF: return -y - z

func noise_3d(x, y, z):
	var xi = int(floor(x)) & 0xFF
	var yi = int(floor(y)) & 0xFF
	var zi = int(floor(z)) & 0xFF
	var xf = x - int(floor(x))
	var yf = y - int(floor(y))
	var zf = z - int(floor(z))
	var u = fade(xf)
	var v = fade(yf)
	var w = fade(zf)

	var aaa = table[table[table[xi    ] + yi    ] + zi    ]
	var aba = table[table[table[xi    ] + yi + 1] + zi    ]
	var aab = table[table[table[xi    ] + yi    ] + zi + 1]
	var abb = table[table[table[xi    ] + yi + 1] + zi + 1]
	var baa = table[table[table[xi + 1] + yi    ] + zi    ]
	var bba = table[table[table[xi + 1] + yi + 1] + zi    ]
	var bab = table[table[table[xi + 1] + yi    ] + zi + 1]
	var bbb = table[table[table[xi + 1] + yi + 1] + zi + 1]

	var x1 = lerp(
		grad_3d(aaa, xf    , yf    , zf    ),
		grad_3d(baa, xf - 1, yf    , zf    ),
		u
	)

	var x2 = lerp(
		grad_3d(aba, xf    , yf - 1, zf    ),
		grad_3d(bba, xf - 1, yf - 1, zf    ),
		u
	)

	var y1 = lerp(x1, x2, v)

	x1 = lerp(
		grad_3d(aab, xf    , yf    , zf - 1),
		grad_3d(bab, xf - 1, yf    , zf - 1),
		u
	)

	x2 = lerp(
		grad_3d(abb, xf    , yf - 1, zf - 1),
		grad_3d(bbb, xf - 1, yf - 1, zf - 1),
		u
	)

	var y2 = lerp(x1, x2, v)

	return lerp(y1, y2, w)
