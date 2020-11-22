extends Node2D

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
		if tile == "Wire": object.id = i
		# add object
		if TILES[tile]["instance"] != null:
			get_node("Object/"+tile).add_child(object)
		i += 1



func spawn_player():
	var new_player = player.instance()
	new_player.position = $Spawnpoint.position
	add_child(new_player)
	new_player.respawn()
