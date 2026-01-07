extends Node2D

@onready var enemyScene = preload("res://scenes/enemy.tscn")
@onready var parent = get_parent()

var wait_time := 15.0
@onready var timer = $spawntimer

var cycles := 0

func _ready():
	timer.wait_time = wait_time
	timer.start()

func _on_spawntimer_timeout():
	cycles += 1
	$CPUParticles2D.emitting = true
	for i in range(randi_range(cycles, (cycles*2))):
		var enemy = enemyScene.instantiate()
		
		add_sibling(enemy)
		enemy.global_position = parent.global_position
	wait_time = wait_time*2
	timer.wait_time = wait_time
	timer.start()
