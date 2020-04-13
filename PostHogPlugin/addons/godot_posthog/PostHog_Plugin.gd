tool
extends EditorPlugin

func _enter_tree():
    add_autoload_singleton("PostHog", "res://addons/godot_posthog/PostHog.gd")

func _exit_tree():
    remove_autoload_singleton("PostHog")
