extends Node

signal swiped(direction)

export (float) onready var MinSpeed

var children
var touch_down

func _ready() -> void:
    children = $Directions.get_children()

func _unhandled_input(event: InputEvent) -> void:
        if event is InputEventScreenTouch:
            if event.pressed and not touch_down:
                touch_down = event
            elif not event.pressed and touch_down:
                var difference = event.position - touch_down.position
                for child in children:
                    if child.applies(difference):
                        emit_signal("swiped", child.SwipeDirection)
                        break
                touch_down = null
