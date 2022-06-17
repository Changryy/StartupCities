extends Node2D
const screen = Vector2(1920,1080)
const player = preload("res://Player/alive/Player.tscn")
const TILE_SIZE = Vector2(100,100)
const TILES = {
	"Spike":{
		"id":1,
		"instance":preload("res://Map/obstacles/Spike.tscn")
	},
	"Flag":{
		"id":2,
		"instance":preload("res://Map/obstacles/Flag.tscn")
	},
	"Spawn":{
		"id":3,
		"instance":null
	},
	"Wires":{
		"id":4,
		"instance":preload("res://Map/obstacles/Wires.tscn")
	},
	"Fire":{
		"id":5,
		"instance":preload("res://Map/obstacles/Fire.tscn")
	}
}
 


# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in TILES:
		init_tiles(tile)
	spawn_player()

func init_tiles(tile):
	var i = 0
	for cell in $TileMap.get_used_cells_by_id(TILES[tile]["id"]):
		# delete tile
		$TileMap.set_cellv(cell,-1)
		# define object
		var object
		if tile == "Spawn": object = $Spawnpoint
		else: object = TILES[tile]["instance"].instance()
		# object position
		object.position = $TileMap.map_to_world(cell)+TILE_SIZE/2+Vector2(0,16)
		# add id to wires
		if tile == "Wires": object.id = i
		# add object
		if TILES[tile]["instance"] != null:
			get_node("Object/"+tile).add_child(object)
		i += 1



func spawn_player():
	var new_player = player.instance()
	new_player.position = $Spawnpoint.position
	add_child(new_player)
	var cam_pos = $Spawnpoint.position - screen/2
	move_camera(cam_pos)


func _physics_process(_delta):
	var cam_pos = lerp($Camera.position, get_node("Player").position - screen/2, 0.05)
	move_camera(cam_pos)

func move_camera(cam_pos):
	if cam_pos.x < 0: cam_pos.x = 0
	if cam_pos.y > 0: cam_pos.y = 0
	if cam_pos.x > $Border.position.x - screen.x: cam_pos.x = $Border.position.x - screen.x
	if cam_pos.y < $Border.position.y: cam_pos.y = $Border.position.y
	$Camera.position = cam_pos
