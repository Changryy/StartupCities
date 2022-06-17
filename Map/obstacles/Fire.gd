extends Area2D

var is_burning := true


func _physics_process(_delta):
	if !is_burning: return
	for area in get_overlapping_areas():
		if area.is_in_group("Extinguisher"): extinguish()



func extinguish():
	is_burning = false
	$Hitbox.queue_free()
	$Fire.emitting = false
	yield(get_tree().create_timer(0.2), "timeout")
	$sound.stop()
	$AnimatedSprite.queue_free()
