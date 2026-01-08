extends StaticBody2D

var player = null
@onready var main = get_tree().root.get_child(0)

@onready var slots = $colors.get_children()

#objects
var aSlots = []
var bSlots = []
var cSlots = []
var dSlots = []

var colors = [Color("red"), Color("green"), Color("blue"), Color("orange"), Color("purple"), Color("darkgray")]

func resetLights():
	for s in slots:
		state = 0
		s.color = Color("white")
		if powered != true:
			s.color = Color("red")

func _ready():
	if dev != true:
		$Camera2D.queue_free()
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
		
	for c in colors:
		listA.append(c)
		listB.append(c)
		listC.append(c)
		listD.append(c)


var powered = true
var state = 0

#colors
var listA = []
var listB = []
var listC = []
var listD = []

var running = false
var dev = true
func _process(_delta):
	if dev and Input.is_action_just_pressed("interact"):
		start()
	if powered != true:
		return
	if running == false:
		$btn.color = Color("green")
		if player:
			if Input.is_action_just_pressed("interact"):
				start()
	else:
		for i in range(5):
			var _index = i-1
			aSlots[i].color = listA[i]
			bSlots[i].color = listB[i]
			cSlots[i].color = listC[i]
			dSlots[i].color = listD[i]
		var updateThese = []
		if phase <= 4:
			if randi_range(1,5) == 5:
				var clone = $audio.duplicate()
				clone.connect("finished", Callable(clone, "queue_free"))
				add_child(clone)
				clone.play()
			
			if randi_range(1,3) != 1:
				updateThese.append(listD)
			if phase <= 3:
				if randi_range(1,3) != 1:
					updateThese.append(listC)
				if phase <= 2:
					if randi_range(1,3) != 1:
						updateThese.append(listB)
					if phase == 1:
						if randi_range(1,3) != 1:
							updateThese.append(listA)
		for l in updateThese:
			popColorList(l)
		
		
		

func popColorList(list):
	var save = list[list.size() - 1]
	list.erase(save)
	list.insert(0, save)

var indA = 0
var indB = 0
var indC = 0
var indD = 0
func start():
	if running:
		return
	$btn.color = Color("darkred")
	running = true
	state = 0
	if false: # return if next branch doesn't work
		for i in range(5):
			aSlots[i].color = listA[i]
			bSlots[i].color = listB[i]
			cSlots[i].color = listC[i]
			dSlots[i].color = listD[i]
	$colors/a3.color = listA[indA]
	$colors/b3.color = listB[indB]
	$colors/c3.color = listC[indC]
	$colors/d3.color = listD[indD]
	phase = 1
	state = 1
	$slotroller.start()
	


func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		player = body


func _on_detection_body_exited(body):
	if body.is_in_group("player"):
		player = null

var phase = 1
func _on_slotroller_timeout():
	if phase == 1:
		resetLights()
	phase += 1
	print(str(phase))
	match phase:
		2,3,4:
			$slotroller.start()
			if phase == 2 or phase == 3 or phase == 4:
				var ding = $phaseDone.duplicate()
				ding.connect("finished", Callable(ding, "queue_free"))
				add_child(ding)
				ding.play()
		5:
			running = false
			phase = 0
			var ding = $done.duplicate()
			ding.connect("finished", Callable(ding, "queue_free"))
			add_child(ding)
			ding.play()
			
		
			
