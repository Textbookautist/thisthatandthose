extends Node2D

var datapath = "user://files/savedata.tres"
@onready var back = $structures/back
@onready var RGB = [back.color.r, back.color.g, back.color.b]

var data: Resource
var color = null

func fullWipe():
	var user_path = "user://files/savedata.tres"

	# Delete the file if it exists
	if FileAccess.file_exists(user_path):
		DirAccess.remove_absolute(user_path)

	# Reload the scene so load_or_create_savedata() runs again
	get_tree().reload_current_scene()


func load_or_create_savedata():
	var user_path = "user://files/savedata.tres"
	var default_path = "res://files/savedata.tres"

	# Ensure directory exists
	var dir := DirAccess.open("user://")
	if not dir.dir_exists("files"):
		dir.make_dir("files")

	# If user save exists, load it
	if FileAccess.file_exists(user_path):
		return load(user_path)

	# Otherwise load default and save it to user://
	var default_data := load(default_path)
	ResourceSaver.save(default_data, user_path)
	return default_data


func _ready():
	$structures/back/btn_start.visible = false
	data = load_or_create_savedata()   # <-- THIS IS THE FIX
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
		if $structures/back/btn_start:
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
		if $structures/colors.visible == false:
			if $structures/back/btn_start:
				$structures/back/btn_start.visible = true
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
	$structures/back/btn_start.queue_free()
	color = rgb
	data.primeColor = rgb
	ResourceSaver.save(data, datapath)
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
	


func _on_fullwipe_btn_pressed():
	fullWipe()
