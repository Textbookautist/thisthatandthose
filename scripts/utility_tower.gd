extends StaticBody2D

@onready var main = get_tree().root.get_child(0)

var initialized = false
var master = false
var active = true
var peers = []
var peerLeft = null
var peerRight = null

var connectedLever = null

@onready var activeLight = $form/base/activeLight

func getLeft():
	return $form/base/pole/leftConnector/connection

func getRight():
	return $form/base/pole/rightConnector/connection

func _process(_delta):
	if active:
		activeLight.color = Color8(255,255,0)
	else:
		activeLight.color = Color8(255,0,0)

func _ready():
	add_to_group("utility_tower")
	add_to_group("structure")
	main.utilities.append(self)

func toggleSignal(source):
	if source.active:
		active = true
	else:
		active = false
	if source == peerRight:
		peerLeft.toggleSignal(self)
	else:
		peerRight.toggleSignal(self)

func toggle(status = null):
	if status != null:
		active = status
	else:
		active = !active
	if peerLeft != null:
		peerLeft.toggleSignal(self)
	if peerRight != null:
		peerRight.toggleSignal(self)
	if connectedLever != null:
		if connectedLever.active != active:
			connectedLever.toggle(active)

func build_network():
	var towers = main.utilities.filter(func(u): return u.is_in_group("utility_tower"))
	towers.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)


	for i in range(towers.size() - 1):
		var a = towers[i]
		var b = towers[i + 1]
		_connect_towers(a, b)

func _sort_by_x(a, b):
	return a.global_position.x < b.global_position.x

func _connect_towers(a, b):
	peerRight = a
	peerLeft = b
	var line = Line2D.new()
	line.width = 4
	line.default_color = Color.WHITE

	var a_pos = a.getRight().global_position
	var b_pos = b.getLeft().global_position

	line.points = [a_pos, b_pos]
	line.default_color = Color8(10,10,10)
	line.width = 2
	line.z_index = 10
	line.modulate.a = 0.05
	main.add_child(line)



func _on_init_timer_timeout():
	$initTimer.queue_free()
	if self == main.utilities[0]:
		master = true
	else:
		return
	
	build_network()
