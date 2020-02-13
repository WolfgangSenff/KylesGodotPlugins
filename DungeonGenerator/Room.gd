extends RigidBody2D
class_name Room

var size

func make_room(_pos, _size):
    position = _pos
    size = _size
    var s = RectangleShape2D.new()
    s.custom_solver_bias = .90
    s.extents = size
    $CollisionShape2D.shape = s
    
func get_center():
    return (position + size) / 2.0
