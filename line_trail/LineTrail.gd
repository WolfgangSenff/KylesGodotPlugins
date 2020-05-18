extends Node
class_name LineTrail

export (int) onready var TrailLength
export (int) onready var TrailWidth
export (Curve2D) onready var TrailWidthCurve
export (Color) onready var DefaultColor
export (Gradient) onready var gradient
export (Texture) onready var texture
export (int, "None", "Tile", "Stretch") onready var TextureMode

var line : Line2D

func _ready():
    line = Line2D.new()
    add_child(line)
    call_deferred("set_all_values")
    
func set_all_values():
    if TrailWidth:
        line.width = TrailWidth
    if TrailWidthCurve:
        line.width_curve = TrailWidthCurve
    if DefaultColor:
        line.default_color = DefaultColor
    if gradient:
        line.gradient = gradient
    if texture:
        line.texture = texture
    if TextureMode != -1:
        line.texture_mode = TextureMode

func _process(delta: float) -> void:
    if line.points.size() > TrailLength:
        line.remove_point(0)
    
    line.add_point(owner.global_position)
