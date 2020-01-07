extends Line2D

func _ready() -> void:
    redraw_line()
    
func redraw_line() -> void:
    var path = get_parent()
    var tessellated_points = path.curve.tessellate()
    points = tessellated_points
