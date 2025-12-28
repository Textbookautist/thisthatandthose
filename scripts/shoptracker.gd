extends Node2D

var datapath = "res://files/savedata.tres"

@onready var data = load(datapath)

var restockTime = null

func _ready():
	restockTime = data.restockTime

var hasRestock = false
func _on_restock_timer_timeout():
	restockTime -= 5
	if restockTime <= 0 and hasRestock == false:
		restockTime = 0
		data.restock = true
		if hasRestock == false:
			hasRestock = true
			ResourceSaver.save(data, datapath)
	else:
		$restockTimer.stop()
