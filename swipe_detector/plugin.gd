tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("SwipeDetector", "Node", preload("res://addons/swipe_detector/SwipeDetector.gd"), preload("res://addons/swipe_detector/icon.png"))

func _exit_tree():
    remove_custom_type("SwipeDetector")
