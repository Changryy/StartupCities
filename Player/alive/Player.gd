extends KinematicBody2D


onready var corpses = get_node("../Corpses")
const corpse = preload("res://Player/dead/Corpse.tscn")
const explosion = preload("res://Player/Explosion.tscn")
onready var animation = $AnimationTree.get("parameters/playback")

onready var spawnpoint = get_node("../Spawnpoint").position

var speed = 500
var gravity = 100
var jumpforce = 1600

var motion = Vector2.ZERO

var dead = false
var in_fire = 0
var fire_dmg = 0.0
var fall_dmg = false
var jumping = false


func _ready():
	for spike in get_node("../Object/Spike").get_children():
		spike.connect("body_entered", self, "_on_Spike_body_entered")
	for wires in get_node("../Object/Wires").get_children():
		wires.connect("body_entered", self, "_on_Wires_body_entered")
	for fire in get_node("../Object/Fire").get_children():
		fire.connect("body_entered", self, "_on_Fire_body_entered")
		fire.connect("body_exited", self, "_on_Fire_body_exited")
	for flag in get_node("../Object/Flag").get_children():
		flag.connect("body_entered", self, "_on_Flag_body_entered")


# warning-ignore:unused_argument
func _physics_process(delta): 
	var snap = Vector2.DOWN * 16 if is_on_floor() else Vector2.ZERO
# warning-ignore:return_value_discarded
	move_and_slide_with_snap(motion, snap, Vector2.UP)

	if animation.get_current_node() == "spawn" or dead: motion = Vector2.ZERO
	else:
		apply_gravity()
		movement()

		if motion.y > 200: animation.travel("fall")
		elif motion.y < -200: animation.travel("jump")
		if in_fire > 0: fire_dmg += delta
		if fire_dmg >= 0.1:
			fire_dmg = 0
			animated_death("explode")


	if position.y > 2000: respawn() # respawn if outside of playable area


	if Input.is_action_just_pressed("ui_cancel"):
		_on_Flag_body_entered(self)
#	if motion.y > 1800 and not jumping: fall_dmg = true
#	elif motion.y > 2400: fall_dmg = true
#	if fall_dmg and is_on_floor() and not dead:
#		fall_dmg = false
#		die("fall")


func apply_gravity():
	if is_on_floor():
		jumping = false
		if Input.is_action_pressed("ui_up"):
			jumping = true
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
	
	if is_on_floor():
		if move_dir != 0: animation.travel("move")
		else: animation.travel("idle")
	motion.x = lerp(motion.x, move_dir*speed, 0.1)


func _on_Spike_body_entered(body):
	if body != self: return
	if dead: return
	for body in $Below.get_overlapping_bodies():
		if body.is_in_group("dead"): return
	die("spike")
#	if (position-spawnpoint).length() > 50 and motion.y > 400: die("spike")

func _on_Wires_body_entered(body):
	if body == self and not dead:
		animated_death("electric")

func _on_Fire_body_entered(body):
	if body == self: in_fire += 1

func _on_Fire_body_exited(body):
	if body == self:
		in_fire -= 1
		if in_fire == 0: fire_dmg = 0

func die(anim):
	dead = true
	motion.y = gravity
	var dead_body = corpse.instance()
	dead_body.flip = $Sprite.flip_h
	dead_body.position = position
	dead_body.motion = motion*Vector2(0.001, 0.01)
	dead_body.anim = anim
	respawn()
	corpses.call_deferred("add_child", dead_body)

func respawn():
	Global.deaths += 1
	motion.y = gravity
	fall_dmg = false
	jumping = false
	$Sprite.flip_h = false
	position = spawnpoint
	$Sound/spawn.play()
	animation.start("spawn")
	yield(get_tree().create_timer(0.5), "timeout")
	dead = false


func animated_death(anim):
	dead = true
	var new_explosion = explosion.instance()
	new_explosion.position = position
	if anim == "explode": get_parent().add_child(new_explosion)
	animation.start(anim)
	yield(get_tree().create_timer(0.5), "timeout")
	if anim == "electric": die(anim)
	else: respawn()


func _on_Flag_body_entered(body):
	if body == self:
		Global.lvl += 1
		if Global.lvl <= 5: get_tree().change_scene("res://Map/levels/Level"+str(Global.lvl)+".tscn")
		else:
			Global.reset()
			get_tree().change_scene("res://other/Title screen.tscn")

