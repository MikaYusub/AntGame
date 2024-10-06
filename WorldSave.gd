extends Node

var loaded_coords = []
var data_in_chunk = []

func add_chunk(coords: Vector2):
    loaded_coords.append(coords)
    data_in_chunk.append([])

func save_chunk(coords: Vector2, data):
    data_in_chunk[loaded_coords.find(coords)] = data

func retrive_chunk(coords: Vector2):
    return data_in_chunk[loaded_coords.find(coords)]