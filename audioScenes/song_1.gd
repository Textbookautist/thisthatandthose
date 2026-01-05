extends Node2D

@onready var note1 = $baritonef
@onready var note2 = $baritonesmall
@onready var note3 = $baritoneg1
@onready var note4 = $baritoneg2
@onready var note5 = $baritoneg3
@onready var timer = $noteTimer

@onready var notes = [note1, note2, note3, note4, note5]

func _ready():
	$noteTimer.start()

func note(n, w):
	var noise = n.duplicate()
	noise.connect("finished", Callable(noise, "queue_free"))
	add_child(noise)
	noise.play()
	if state > 5:
		
		var wt = randf_range(0.8, 4.0)
		timer.wait_time = wt
	else:
		timer.wait_time = w

var state = 0
func _on_note_timer_timeout():
	match state:
		0:
			note(note1, 1.5)
		1:
			note(note2, 1.6)
		2:
			note(note5, 5.0)
		3:
			note(note1, 3.0)
		4:
			note(note4, 2.0)
		5:
			note(note1, 3.0)
		_:
			notes.shuffle()
			note(notes[0],  1.0)
	state += 1
	#if state == 3:
	#	state = 0
	timer.start()
