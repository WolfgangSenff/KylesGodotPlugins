tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("PathLine2D", "Line2D", preload("res://addons/path_line/PathLine2D.gd"), preload("res://addons/path_line/icon.png"))

func _exit_tree():
    remove_custom_type("PathLine2D")
