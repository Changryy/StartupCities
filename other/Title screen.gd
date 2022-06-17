extends Node2D



func _on_TextureButton_pressed():
	get_tree().change_scene_to(preload("res://Map/levels/Level1.tscn"))

