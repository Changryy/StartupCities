extends KinematicBody2D

var motion = Vector2(1,1)
var flip = false

func _ready():
	$Sprite.flip_h = flip


# warning-ignore:unused_argument
func _physics_process(delta):
	motion = lerp(motion, Vector2.ZERO, 0.05)
# warning-ignore:return_value_discarded
	move_and_collide(motion)
