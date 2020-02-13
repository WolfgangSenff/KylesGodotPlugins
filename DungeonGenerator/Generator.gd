extends TileMap
class_name Generator

var room_scene = preload("res://Room.tscn")

export var tile_size = 32
export var num_rooms = 50
export var min_size = 4
export var max_size = 10
export var hspread = 400
export var space_between_rooms = 2
export var cull = 0.5
export var is_constant_corridor_width = false
export var randomize_corridor_width_every_step = true
export var max_corridor_width = 6
export var min_corridor_width = 2
export var is_debug = true
var path

func _ready():
    randomize()
    
func generate_dungeon():
    yield(make_rooms(), "completed")
    if not is_debug:
        make_map()
    
func make_rooms():
    for i in num_rooms:
        var pos = Vector2(rand_range(-hspread, hspread), 0)
        var r = room_scene.instance()
        var w = min_size + randi() % (max_size - min_size)
        var h = min_size + randi() % (max_size - min_size)
        r.make_room(pos, Vector2(w, h) * tile_size)
        $Rooms.add_child(r)
        
    yield(get_tree().create_timer(1.2), "timeout")
    var room_positions = []
    for room in $Rooms.get_children():
        if randf() < cull:
            room.queue_free()
        else:
            room.mode = RigidBody2D.MODE_STATIC
            room_positions.push_back(room.position)
    
    yield(get_tree(), "idle_frame")
    path = find_mst(room_positions)

func _draw():
    if is_debug:
        for room in $Rooms.get_children():
            draw_rect(Rect2(room.position - room.size, room.size * 2),
                    Color(32, 228, 0), false)
        if path:
            for p in path.get_points():
                for c in path.get_point_connections(p):
                    var pp = path.get_point_position(p)
                    var cp = path.get_point_position(c)
                    draw_line(pp, cp, Color(1, 1, 0), 15, true)

func _process(delta):
    if is_debug:
        update()

func _input(event):
    if is_debug:
        if event.is_action_pressed("ui_select"):
            for n in $Rooms.get_children():
                n.queue_free()
            path = null
            make_rooms()
        if event.is_action_pressed("ui_focus_next"):
            make_map()

func find_mst(positions):
    var astar_map = AStar2D.new()
    astar_map.add_point(astar_map.get_available_point_id(), 
                        positions.pop_front())
                        
    while positions:
        var min_dist = INF
        var min_p = null
        var p = null
        
        for p1 in astar_map.get_points():
            p1 = astar_map.get_point_position(p1)
            for p2 in positions:
                if p1.distance_squared_to(p2) < min_dist:
                    min_dist = p1.distance_squared_to(p2)
                    min_p = p2
                    p = p1
        var n = astar_map.get_available_point_id()
        astar_map.add_point(n, min_p)
        astar_map.connect_points(astar_map.get_closest_point(p), n)
        positions.erase(min_p)
        
    return astar_map

func make_map():
    clear()
    
    var corridors = []
    
    for room in $Rooms.get_children():
        var s = (room.size / tile_size).floor()
        var pos = world_to_map(room.position)
        var ul = (room.position / tile_size).floor() - s
        for x in range(space_between_rooms, s.x * 2 - (space_between_rooms - 1)):
            for y in range(space_between_rooms, s.y * 2 - (space_between_rooms - 1)):
                set_cell(x + ul.x, y + ul.y, 0, false, false, false, Vector2(3, 3))
    
        var p = path.get_closest_point(room.position)
        for conn in path.get_point_connections(p):
            if not conn in corridors:
                var start = world_to_map(path.get_point_position(p))
                var end = world_to_map(path.get_point_position(conn))
                carve_path(start, end)
            corridors.push_back(p)
            
    update_bitmask_region()
    update_dirty_quadrants()
    
func carve_path(pos1, pos2):
    var x_diff = sign(pos2.x - pos1.x)
    var y_diff = sign(pos2.y - pos1.y)
    
    if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
    if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
    
    var x_y = pos1
    var y_x = pos2
    if (randi() % 2) > 0:
        x_y = pos2
        y_x = pos1
    
    var corridor_width = max_corridor_width
    if not is_constant_corridor_width:
        corridor_width = floor(rand_range(min_corridor_width, max_corridor_width))
    
    for x in range(pos1.x, pos2.x, x_diff):
        if randomize_corridor_width_every_step:
            corridor_width = floor(rand_range(min_corridor_width, max_corridor_width))
        for w in (corridor_width - 1):
            set_cell(x, x_y.y + (y_diff * w), 0, false, false, false, Vector2(3, 3))
    for y in range(pos1.y, pos2.y, y_diff):
        if randomize_corridor_width_every_step:
            corridor_width = floor(rand_range(min_corridor_width, max_corridor_width))
        for w in (corridor_width - 1):
            set_cell(y_x.x + (x_diff * w), y, 0, false, false, false, Vector2(3, 3))
    
func get_random_room():
    var idx = randi() % $Rooms.get_child_count()
    return $Rooms.get_child(idx)
