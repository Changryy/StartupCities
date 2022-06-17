extends Area2D


func _ready():
	$Slime.emitting = true
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
