extends StaticBody2D

var twin = null

func _ready():
	add_to_group("transportgate")

func get_upper():
	return $upper.global_position
func get_lower():
	return $lower.global_position

func cooldowner():
	$cooldowntimer.start()

var cooldown = false
func teleport_twin(t, direction):
	if cooldown:
		return
	cooldown = true
	twin.cooldown = true
	cooldowner()
	twin.cooldowner()
	match direction:
		"up":
			var globpos = twin.get_upper()
			t.global_position = globpos
		"down":
			var globpos = twin.get_lower()
			t.global_position = globpos
			

func _process(_delta):
	if twin == null:
		return
	if cooldown:
		$CPUParticles2D.emitting = false
	else:
		if $CPUParticles2D.emitting == false:
			$CPUParticles2D.emitting = true
	var things = $detect.get_overlapping_bodies()
	for t in things:
		if t.is_in_group("player"):
			var playerdir = t.velocity.y
			if playerdir > 0:
				teleport_twin(t, "down")
			elif playerdir < 0:
				teleport_twin(t, "up")

func _on_finder_timeout():
	if twin != null:
		return
	var gates = []
	for obj in $pairfinder.get_overlapping_bodies():
		if obj.is_in_group("transportgate"):
			gates.append(obj)
	
	var removables = []
	for gate in gates:
		if gate.twin != null:
			removables.append(gate)
	while removables.size() > 0:
		gates.erase(removables[0])
		removables.erase(removables[0])
	
	for gate in gates:
		if gate == self:
			continue
		if gate.twin == null:
			twin = gate
			gate.twin = self
			break
	$pairfinder.queue_free()
	if twin == null:
		$CPUParticles2D.emitting = false
			


func _on_cooldowntimer_timeout():
	cooldown = false
