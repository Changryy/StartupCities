extends KinematicBody2D


onready var corpses = get_node("../Corpses")
const corpse = preload("res://Player/dead/Corpse.tscn")
onready var animation = $AnimationTree.get("parameters/playback")

onready var spawnpoint = get_node("../Spawnpoint").position

var speed = 500
var gravity = 100
var jumpforce = 1300

var motion = Vector2.ZERO



func _ready():
	for spike in get_node("../Object/Spike").get_children():
		spike.connect("body_entered", self, "_on_Spike_body_entered")


# warning-ignore:unused_argument
func _physics_process(delta): 
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2.UP)

	apply_gravity()
	movement()

	if motion.y > 100: animation.travel("fall")
	elif motion.y < -50: animation.travel("jump")


	if position.y > 2000: position = spawnpoint # respawn if outside of playable area



func apply_gravity():
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = -jumpforce
			$Sound/jump.play()
		else: motion.y = 0
	else: motion.y += gravity

func movement():
	var move_dir = 0
	
	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
		move_dir += 1
	if Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
		move_dir -= 1
	
	if move_dir != 0: animation.travel("run")
	else: animation.travel("idle")
	motion.x = lerp(motion.x, move_dir*speed, 0.1)


func _on_Spike_body_entered(body):
	if body == self and (position-spawnpoint).length() > 50: respawn()


func respawn():
	motion.y = gravity
	var dead_body = corpse.instance()
	dead_body.flip = $Sprite.flip_h
	dead_body.position = position
	dead_body.motion = motion*Vector2(0.001, 0.01)
	position = spawnpoint
	corpses.call_deferred("add_child", dead_body)







