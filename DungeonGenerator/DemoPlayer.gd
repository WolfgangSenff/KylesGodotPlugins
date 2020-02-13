extends KinematicBody2D

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

export var speed = 50.0

func _physics_process(delta):
    var direction = Vector2.ZERO
    if Input.is_action_pressed("ui_right"):
        direction += Vector2.RIGHT
    if Input.is_action_pressed("ui_left"):
        direction += Vector2.LEFT
    if Input.is_action_pressed("ui_down"):
        direction += Vector2.DOWN
    if Input.is_action_pressed("ui_up"):
        direction += Vector2.UP
    
    if direction != Vector2.ZERO:
        print("Player pos before move: " + str(position))
        rotation = direction.normalized().angle()
        move_and_slide(direction.normalized() * speed)
        if anim_player.current_animation == "Idle" or !anim_player.is_playing():
            anim_player.play("Walk")
    else:
        anim_player.play("Idle")
