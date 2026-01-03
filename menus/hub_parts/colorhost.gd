extends CharacterBody2D

var datapath = "user://files/savedata.tres"
@onready var kidScene = preload("res://menus/hub_parts/colorhost.tscn")
@onready var data = load(datapath)

var color = null

# Movement tuning
var wander_speed = 40.0
var wander_change_interval = 1.5
var wander_timer = 0.0
var wander_direction = Vector2.ZERO

# Circling tuning
var circle_center := Vector2.ZERO
var circle_radius := 40.0
var circle_angle := 0.0
var circle_speed := 1.5   # radians per second

var adult = true
var personality = 0.0
var uniter = 0

var state = 0
var states = ["wandering", "idling", "circling", "standing", "chatting"]

func _ready():
	add_to_group("alive")
	add_to_group("colorhost")
	
	if randi_range(1,5) == 1:
		notGoingToChat = true
	
	personality = randi_range(-2, 2)
	if randi_range(1,2) == 1:
		uniter = -1
	else:
		uniter = 1
	$base.color = color
	
	if adult != true:
		scale = Vector2(0.5, 0.5)
		var colorData = data.ownedColors
		var myColor = $base.color
		var myColor8 = Color8(int(myColor.r * 255), int(myColor.g * 255), int(myColor.b * 255))
		colorData.append(myColor8)
		colorData.sort()
		data.ownedColors = colorData
		ResourceSaver.save(data, datapath)
	
	# Start wandering by default
	state = states.find("wandering")
	_pick_new_wander_direction()


func getColor():
	return $base.color


func unite(host):
	var c1: Color = host.getColor()
	var c2: Color = getColor()
	var c3: Color = (c1 + c2) / 2
	c3.a = 1.0
	var kid = kidScene.instantiate()
	kid.color = c3
	kid.adult = false
	add_sibling(kid)
	kid.global_position = global_position
	kid.global_position.y -= 15
	kid.z_index = 1
	chatting = false
	chattingTo = null
	chatProgress = 0
	host.queue_free()


var chatProgress = 0
func _process(_delta):
	if chatting and is_instance_valid(chattingTo):
		chatProgress += 1
		if chatProgress == 500:
			if (chattingTo.uniter + uniter) == 0 and chattingTo.adult and adult:
				if chattingTo.uniter == -1:
					chattingTo.unite(self)
				else:
					unite(chattingTo)
			else:
				chatting = false
	else:
		chatting = false
		chatProgress = 0
		chattingTo = null


func _physics_process(delta):
	if chatting:
		return
	match states[state]:
		"wandering":
			_do_wandering(delta)
		"circling":
			_do_circling(delta)
		_:
			velocity = Vector2.ZERO * delta
	
	move_and_slide()

func _do_wandering(delta):
	wander_timer -= delta

	# Pick a new direction occasionally
	if wander_timer <= 0:
		_pick_new_wander_direction()

	velocity = wander_direction * wander_speed

func _pick_new_wander_direction():
	wander_timer = wander_change_interval + randf_range(-0.5, 0.5)
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _do_circling(delta):
	circle_angle += circle_speed

	var offset = Vector2(
		cos(circle_angle),
		sin(circle_angle)
	) * circle_radius

	var target_pos = circle_center + offset
	var direction = (target_pos - global_position).normalized()

	velocity = direction * wander_speed * delta*60

var hosts = []
func _on_pairing_body_entered(body):
	if body.is_in_group("colorhost"):
		hosts.append(body)


func _on_pairing_body_exited(body):
	if body.is_in_group("colorhost"):
		if body in hosts:
			hosts.erase(body)

var chattingTo = null
var chatting = false
var notGoingToChat = false
func _on_chat_timer_timeout():
	if hosts.size() == 0 or chatting or notGoingToChat:
		return
	for host in hosts:
		if host.chatting or host == self:
			continue
		if (host.personality - personality) == 0 or (host.personality + personality) == 0:
			chatting = true
			chattingTo = host
			host.chatting = true
			host.chattingTo = self
