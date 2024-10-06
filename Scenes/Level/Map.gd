extends Node2D

const chunknode = preload("res://Scenes/ChunkLoading/chunk_node.tscn")

var render_distance = 1
var chunk_size = 32
var current_chunk = Vector2()
var previous_chunk = Vector2()

var chunk_loaded = false
var player
var circumnavigation = false
var revolution_distance = 8

@onready var active_coords = []
@onready var active_chunks = []


func _ready():
    player = get_parent().get_node("Player")
    current_chunk = get_player_chunk(player.global_position)
    load_chunk()


func _process(_delta):
    current_chunk = get_player_chunk(player.global_position)
    if previous_chunk != current_chunk:
        if !chunk_loaded:
            load_chunk()
    else:
        chunk_loaded = false
    previous_chunk = current_chunk


func get_player_chunk(player_position: Vector2) -> Vector2:
    var chunk_pos = Vector2()
    chunk_pos.x = int(player_position.x / chunk_size) 
    chunk_pos.y = int(player_position.y / chunk_size)
    if player_position.x < 0:
        chunk_pos.x -= 1
    if player_position.y < 0:
        chunk_pos.y -= 1
    return chunk_pos


func load_chunk():
    var render_bounds = (float(render_distance)*2.0)+1.0
    var loading_coords = []

    for x in range(render_bounds):
        for y in range(render_bounds):
            var _x = (x+1) - (round(render_bounds/2.0)) + current_chunk.x
            var _y = (y+1) - (round(render_bounds/2.0)) + current_chunk.y

            var chunk_coords = Vector2(_x, _y)

            var chunk_key = get_chunk_key(chunk_coords)
            loading_coords.append(chunk_coords)

            if active_coords.find(chunk_coords) == -1:
                var chunk = chunknode.instantiate()
                chunk.position = chunk_coords * chunk_size
                active_chunks.append(chunk)
                active_coords.append(chunk_coords)
                chunk.start(chunk_key)
                add_child(chunk)

    var deleting_chunks = []
    for x in active_coords:
        if loading_coords.find(x) == -1:
            deleting_chunks.append(x)
    for x in deleting_chunks:
        var index = active_coords.find(x)
        active_chunks[index].save()
        active_chunks.erase(active_chunks[index])
        active_coords.erase(active_coords[index])
    
    chunk_loaded = true


func get_chunk_key(_coords: Vector2) -> Vector2:
    var key = _coords
    if !circumnavigation:
        return key
    key.x = wrapf(_coords.x, -revolution_distance, revolution_distance + 1)
    return key
