extends CharacterBody2D


@onready var main = get_tree().root.get_child(0)
#@onready var colorSeed = main.seedArray
@onready var colorSeed = []

var dev = true

var nemesisSeed: int

func calculateNemesisSeed():
	var value = 0.0

	for i in colorSeed:
		var addition = (i + 1) * PI
		value += addition

		# Zero corruption: irrational fracture prevents cancellation
		if i == 0:
			value = -(value + sqrt(2))

	# Final distortion layer
	value = value * PI + sqrt(3)

	# Convert to a stable long integer
	var s = str(abs(value))
	s = s.replace(".", "")
	s = s.replace("e", "")
	s = s.replace("-", "")

	# Guarantee minimum length by padding with deterministic digits
	while s.length() < 15:
		s += "7"

	nemesisSeed = int(s)
	print(nemesisSeed)



func pad_to_three(n: int) -> String:
	var s = str(n)
	while s.length() < 3:
		s = "0" + s
	return s


func generateRGB():
	
	#colorSeed = [000,000,000]
	#return
	
	var randR = randi_range(0,255)
	var randG = randi_range(0,255)
	var randB = randi_range(0,255)

	var arR = pad_to_three(randR).split("")
	var arG = pad_to_three(randG).split("")
	var arB = pad_to_three(randB).split("")

	for i in arR:
		colorSeed.append(int(i))
	for i in arG:
		colorSeed.append(int(i))
	for i in arB:
		colorSeed.append(int(i))


func _ready():
	if dev:
		generateRGB()
	calculateNemesisSeed()

func _process(delta):
	if dev and Input.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()
