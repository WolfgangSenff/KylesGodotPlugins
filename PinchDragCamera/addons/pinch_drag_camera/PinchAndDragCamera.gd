extends Camera2D

export (float) var ZoomFactor = 0.1
export (float) var ZoomEpsilon = 0.1

var tracked_points = {}

var initial_zoom
var initial_pos

var zoom_direction = 0 # Zooming out

func _ready() -> void:
    initial_pos = global_position
    initial_zoom = zoom
    zoom_direction = 0

func reset_camera() -> void:
    global_position = initial_pos
    zoom = initial_zoom
    zoom_direction = 0
    tracked_points.clear()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var tracked_size = tracked_points.size()
        var event_index = event.index
        # Set initial points
        if event.is_pressed():
            tracked_points[event_index] = event
        elif tracked_size > 0 and tracked_size < 3: # Lazy, ignoring every gesture greater than 2 touches though
            tracked_points.erase(event_index)
        elif tracked_size >= 3:
            tracked_points.clear()
    elif event is InputEventScreenDrag and tracked_points.size() > 0:
        var tracked_size = tracked_points.size()
        var event_index = event.index
        if tracked_size == 1: # Handle dragging
            global_position -= event.relative
        elif tracked_size == 2: # Handle pinch/zoom
            var first_tracked_touch = tracked_points.values()[0]
            var second_tracked_touch = tracked_points.values()[1]    
            var initial_distance = second_tracked_touch.position.distance_squared_to(first_tracked_touch.position)
            var relative_distance = event.relative.distance_squared_to(first_tracked_touch.position if event.index == first_tracked_touch.index else second_tracked_touch.position)
            var comparative_distance = relative_distance - initial_distance
            if comparative_distance > ZoomEpsilon:
                zoom_direction = -1
            elif comparative_distance < -ZoomEpsilon:
                zoom_direction = 1
            else:
                zoom_direction = 0

func _process(delta: float) -> void:
    if zoom_direction != 0:
        var zoom_amount = zoom_direction * ZoomFactor
        var zoom_vector = Vector2(zoom_amount, zoom_amount)
        zoom += zoom_vector * delta
