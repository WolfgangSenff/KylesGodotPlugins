extends Node2D

onready var player := $Player
onready var dungeon = $Generator

func _ready():
    yield(dungeon.generate_dungeon(), "completed")
    var random_room = dungeon.get_random_room()
    player.set_deferred("position", random_room.position)
