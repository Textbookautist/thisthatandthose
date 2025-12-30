extends StaticBody2D


@onready var wall1 = $wallsegment
@onready var wall2 = $wallsegment2
@onready var wall3 = $wallsegment3
@onready var wall4 = $wallsegment4

@onready var walls = [wall1, wall2, wall3, wall4]


func remove(w):
	walls.erase(w)
	if walls.size() == 0:
		queue_free()

func _ready():
	add_to_group("obstacle")
	for w in walls:
		if randi_range(1,3) == 1:
			w.destroyObstacle()
	if walls.size() == 0:
		queue_free()

func destroyObstacle():
	if walls.size() == 0:
		queue_free()
	walls.shuffle()
	var to_remove = []
	
	for w in walls:
		if randi_range(1,3) == 1:
			to_remove.append(w)

	for w in to_remove:
		remove(w)

	
	

func _process(_delta):
	if walls.size() == 0:
		queue_free()


func _on_destruction_body_entered(body):
	var globpos = global_position
	if body.is_in_group("player"):
		if body.velocity.x > 0 and (body.global_position.x < globpos.x):
			destroyObstacle()
		elif  body.velocity.x < 0 and (body.global_position.x > globpos.x):
			destroyObstacle()
		elif body.velocity.y > 0 and (body.global_position.y < globpos.y):
			destroyObstacle()
		elif body.velocity.y < 0 and (body.global_position.y > globpos.y):
			destroyObstacle()
