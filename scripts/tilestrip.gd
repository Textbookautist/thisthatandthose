extends Node2D

@onready var coinScene = preload("res://scenes/coin.tscn")

var coin = null

var color = Color("white")

func _ready():
	$ColorRect.color = color
	rotate(randf_range(0.0, 175.0))
	var width = randi_range(-2,2)
	$ColorRect.size.y += width
	
	


func _on_safezone_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.safeMove(self, 1)


func _on_safezone_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.safeMove(self, -1)


func _on_coin_timer_timeout():
	$coinTimer.queue_free()
	if randi_range(1,2) == 1:
		coin = coinScene.instantiate()
		add_child(coin)
		coin.global_position = global_position
