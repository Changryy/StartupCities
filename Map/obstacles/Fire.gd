extends Area2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	for area in get_overlapping_areas():
		if area.is_in_group("Extinguisher"):
			$Hitbox.queue_free()
			$Fire.emitting = false
			$sound.stop()
			$AnimatedSprite.queue_free()
