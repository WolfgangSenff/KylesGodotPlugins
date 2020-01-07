extends Node2D

onready var camera = $PinchDragCamera2D

func _on_Button4_pressed() -> void:
    camera.reset_camera()
