extends StaticBody2D


@onready var wallUL = [$colUL, $walls/colorUL]
@onready var wallUR = [$colUR, $walls/colorUR]
@onready var wallBL = [$colBL, $walls/colorBL]
@onready var wallBR = [$colBR, $walls/colorBR]

@onready var walls = [wallUL, wallUR, wallBL, wallBR]


func remove(w):
	for part in w:
		part.queue_free()
		walls.erase(w)

func _ready():
	add_to_group("obstacle")
	for w in walls:
		if randi_range(1,3) == 1:
			remove(w)

func destroyObstacle():
	if walls.size() == 0:
		queue_free()
	walls.shuffle()
	remove(walls[0])

func _process(_delta):
	if walls.size() == 0:
		queue_free()
