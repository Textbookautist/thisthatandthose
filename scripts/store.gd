extends Node2D

var datapath = "res://files/savedata.tres"
@onready var podiumScene = preload("res://scenes/store_podium.tscn")
@onready var data = load(datapath)
@onready var base = $pods


var needRestock = false

func _ready():
	needRestock = data.restock
	var colors = [data.c1, data.c2, data.c3]
	for i in range(3):
		var pod = podiumScene.instantiate()
		if i == 0:
			if data.c1 != null:
				pod.color = colors[i]
			else:
				pod.color = Color("white")
				pod.hasStock = false
			
		elif i == 1:
			if data.c2 != null:
				pod.color = colors[i]
			else:
				pod.color = Color("white")
				pod.hasStock = false
			
		elif i == 2:
			if data.c3 != null:
				pod.color = colors[i]
			else:
				pod.color = Color("white")
				pod.hasStock = false
			
		pod.needsRestock = needRestock
		base.add_child(pod)
		pod.position.x += 50*i

func updatePoints(podium):
	get_parent().update_points()
	updateData(podium)

func updateData(pod):
	var pods = base.get_children()
	for p in pods:
		if "points" not in p:
			pods.erase(p)
	var updated = -1
	for i in range(3):
		var index = i-1
		if pods[index] == pod:
			updated = index
	
	if updated == 0:
		data.c1 = null
	elif updated == 1:
		data.c2 = null
	else:
		data.c3 = null
	ResourceSaver.save(data, datapath)

func _on_restockchecker_timeout():
	var pods = base.get_children()
	for p in pods:
		if "points" not in p:
			pods.erase(p)
	if pods[0].wasRestock:
		data.c1 = pods[0].get_color()
		data.c2 = pods[1].get_color()
		data.c3 = pods[2].get_color()
		ResourceSaver.save(data, datapath)
