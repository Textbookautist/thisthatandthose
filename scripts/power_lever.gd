extends StaticBody2D

@onready var main = get_tree().root.get_child(0)

var connectedTower = null
var active = false

var onRotation = 45
var offRotation = -45

func toggle(status=null):
	for t in main.utilities:
		if status != null:
			t.active = status
			active = status
		else:
			t.active = !t.active
			active = !active
	if active:
		$lever.rotation = onRotation
		$lever/shaft/tip.color = Color8(255,255,0)
	else:
		$lever.rotation = offRotation
		$lever/shaft/tip.color = Color8(255,0,0)

func togglesss(status=null):
	if status == null:
		active = !active
	else:
		active = status
	if connectedTower.active != active:
		connectedTower.toggle(active)

func _process(_delta):
	if active:
		$lever.rotation = onRotation
		$lever/shaft/tip.color = Color8(255,255,0)
	else:
		$lever.rotation = offRotation
		$lever/shaft/tip.color = Color8(255,0,0)

func _ready():
	add_to_group("uLever")
	main.utilities.append(self)
	var closest = main.utilities[0]
	var towerDistance = global_position.distance_to(closest.global_position)
	for u in main.utilities:
		if u.is_in_group("uLever"):
			continue
		if u.connectedLever == null and (global_position.distance_to(u.global_position) < towerDistance):
			closest = u
			towerDistance = global_position.distance_to(u.global_position)
	
	closest.connectedLever = self
	connectedTower = closest
	active = connectedTower.active

func _on_detector_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("alive"):
		toggle()
