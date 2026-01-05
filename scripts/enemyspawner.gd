extends Node2D

@onready var enemyScene = preload("res://scenes/enemy.tscn")

var wait_time = 15.0
@onready var timer = $spawntimer

func _ready():
	timer.wait_time = wait_time
	timer.start()

func _on_spawntimer_timeout():
	$CPUParticles2D.emitting = true
	for i in range(randi_range(1,3)):
		var enemy = enemyScene.instantiate()
		
		add_sibling(enemy)
		enemy.global_position = global_position
