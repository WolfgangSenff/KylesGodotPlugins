tool
extends EditorPlugin


func _enter_tree() -> void:
    add_custom_type("LineTrail", "Node", preload("res://addons/line_trail/LineTrail.gd"), preload("res://addons/line_trail/icon.png"))


func _exit_tree() -> void:
    remove_custom_type("LineTrail")
