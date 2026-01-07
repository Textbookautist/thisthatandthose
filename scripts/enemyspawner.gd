extends Node2D

@onready var enemyScene = preload("res://scenes/enemy.tscn")
@onready var parent = get_parent()
@onready var main = get_tree().root.get_child(0)

var wait_time := 15.0
@onready var timer = $spawntimer

var cycles := 0

func _ready():
	timer.wait_time = wait_time
	timer.start()

func spawnOne():
	var enemy = enemyScene.instantiate()
	enemy.global_position = parent.global_position
	main.add_child(enemy)

func _on_spawntimer_timeout():
	cycles += 1
	$CPUParticles2D.emitting = true
	for i in range(randi_range(cycles, (cycles*2))):
		call_deferred("spawnOne")
	wait_time = wait_time*2
	timer.wait_time = wait_time
	timer.start()
