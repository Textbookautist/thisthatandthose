extends StaticBody2D

var player = null
@onready var main = get_tree().root.get_child(0)

@onready var slots = $colors.get_children()

var aSlots = []
var bSlots = []
var cSlots = []
var dSlots = []

func _ready():
	for s in slots:
		var sName = s.name
		var parts = sName.split("")
		match parts[0]:
			"a":
				aSlots.append(s)
			"b":
				bSlots.append(s)
			"c":
				cSlots.append(s)
			"d":
				dSlots.append(s)

var active = false
func _process(delta):
	pass
	
	
