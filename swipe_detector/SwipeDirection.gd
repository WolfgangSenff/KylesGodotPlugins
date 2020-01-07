extends Node

export (Vector2) var SwipeDirection
export (float) onready var AngleTolerance
var upper_bound
var lower_bound

func _ready() -> void:
    var rad_tol = deg2rad(AngleTolerance)
    upper_bound = SwipeDirection.angle() + rad_tol
    lower_bound = SwipeDirection.angle() - rad_tol

func applies(relative_direction : Vector2) -> bool:
    var rel_angle = relative_direction.normalized().angle()
    return lower_bound < rel_angle and rel_angle < upper_bound
