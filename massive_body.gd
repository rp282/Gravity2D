class_name MassiveBody
extends Node2D


@export var mass : float
@export var glow_factor = 0.0001
var color : Color
var radius : float
var mesh : MeshInstance2D
var joinable : bool
var velocity : Vector2
var universe : Universe

func _process(delta):
    if position.x + radius + velocity.x > universe.x_max || position.x - radius + velocity.x < 0:
        velocity.x = -velocity.x
    if position.y + radius + velocity.y > universe.y_max || position.y - radius + velocity.y < 0:
        velocity.y = -velocity.y
    position += velocity
    queue_redraw()

var glow = 1
func _draw():
#    if color.v > 0.8:
#        glow = -1
#    if color.v < 0.2:
#        glow = 1
#    match glow:
#        1:
#            color = color.lightened(glow_factor)
#        -1:
#            color = color.darkened(glow_factor)
    draw_circle(Vector2(0,0), radius, color)


func initialize(u: Universe, m: float, pos: Vector2, c: Color, v: Vector2 = Vector2(0, 0)):
    mass = m
    radius = m / 2
    position = pos
    color = c
    velocity = v
    universe = u
