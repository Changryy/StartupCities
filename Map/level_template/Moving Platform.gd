extends Node2D

export (int) var id = 0

const SPEED = 200
const EASING = 100

var velocity = 0
var returning = false
var on = false

onready var x = $Platform

# Called when the node enters the scene tree for the first time.
func _ready():
	$Destination/Sprite.hide()


func _physics_process(delta):
	if on:
		var destination = Vector2()
		var start = Vector2()
		if returning: start = $Destination.position
		else: destination = $Destination.position
		
		var distance = min((destination-x.position).length(), (start-x.position).length())
		velocity = min(SPEED * (distance/EASING), SPEED)
		
		if (destination-x.position).length() < 10: returning = !returning
		elif velocity < 10: velocity = 10
	
		x.position += (destination-x.position).normalized()*velocity*delta



# warning-ignore:unused_argument
func _on_Wires_body_entered(body):
	on = true
