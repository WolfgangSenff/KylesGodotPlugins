extends Node
class_name SwipeDetector

signal swiped(direction)

export (float) onready var MinSpeed

export (PoolVector2Array) var swipe_directions
export (float) var AngleToleranceInDegrees
var touch_down
var rad_tol

func _ready() -> void:
    rad_tol = deg2rad(AngleToleranceInDegrees)

func _unhandled_input(event: InputEvent) -> void:
        if event is InputEventScreenTouch:
            if event.pressed and not touch_down:
                touch_down = event
            elif not event.pressed and touch_down:
                var difference = event.position - touch_down.position
                for child in swipe_directions:
                    if applies_to(child, difference):
                        emit_signal("swiped", child)
                        break
                touch_down = null

func applies_to(direction : Vector2, relative_direction : Vector2) -> bool:
    var upper_bound = direction.angle() + rad_tol
    var lower_bound = direction.angle() - rad_tol
    var rel_angle = relative_direction.normalized().angle()
    return lower_bound < rel_angle and rel_angle < upper_bound
