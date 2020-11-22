extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	self.play("Click")
	get_node("../AnimationPlayer2").play("fade")
	get_node("../Timer").start()


func _on_Timer_timeout():
	get_tree().change_scene("res://Map/level_template/Level.tscn")
