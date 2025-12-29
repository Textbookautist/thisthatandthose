extends Node2D

@onready var data: Resource = load("res://files/savedata.tres")
@onready var back = $structures/back
@onready var RGB = [back.color.r, back.color.g, back.color.b]

var color = null

func _ready():
	$structures/doors.visible = true
	if data.primeColor != null:
		color = data.primeColor
		$structures/back/btn_start.modulate = color
	if data.selectedColor != null:
		var col = data.selectedColor
		$structures/back.color = col


var phase = 0
var started = false
func startup():
	
	phase += 1
	if phase < 15:
		pass
	elif phase < 300:
		$structures/doors/right.position.x += 3
		$structures/doors/left.position.x -= 3
	if phase >= 200:
		$structures/back/btn_start.disabled = false
		started = true


func _process(_delta):
	
	if Input.is_action_just_pressed("space"):
		started = true
		phase = 300
		$structures/doors/right.position.x += 550
		$structures/doors/left.position.x -= 550
	startup()
	if started:
		RGB.shuffle()
		var direction = randi_range(0,1)
		if direction == 1:
			RGB[1] += 0.1
		else:
			RGB[1] -= 0.1



func _on_btn_start_pressed():
	if color == null:
		$structures/back/btn_start.visible = false
		$structures/colors.visible = true
		return
	get_tree().change_scene_to_file("res://menus/hub.tscn")


func select_color(rgb):
	color = rgb
	data.primeColor = rgb
	ResourceSaver.save(data, "res://files/savedata.tres")
	$structures/colors/colortimer.start()
	$structures/colors.visible = false

func _on_btn_r_pressed():
	select_color(Color8(255,0,0))
func _on_btn_g_pressed():
	select_color(Color8(0,255,0))
func _on_btn_b_pressed():
	select_color(Color8(0,0,255))


func _on_colortimer_timeout():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
