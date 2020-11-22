extends Area2D
var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for platform in get_node("../../../Platforms").get_children():
# warning-ignore:return_value_discarded
		if platform.id == id: connect("body_entered", platform, "_on_Wires_body_entered")



func _physics_process(delta):
	if $Sprite.frame == 0: $sparks.play()




