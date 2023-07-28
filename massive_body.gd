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

func _ready():
    add_to_group("bodies")

func _process(delta):
    var net_force = Vector2.ZERO
    for other_body in get_tree().get_nodes_in_group("bodies"):
        if other_body == self:
            continue
        var direction = position.direction_to(other_body.position)
        var force_magnitude = universe.gravity * mass * other_body.mass / position.distance_squared_to(other_body.position)
        net_force += direction * force_magnitude
    
    var acceleration = net_force / mass
    velocity += acceleration * delta
    
    # Check for collisions
    for other_body in get_tree().get_nodes_in_group("bodies"):
        if other_body == self:
            continue
        if position.distance_to(other_body.position) < radius + other_body.radius:
            # Colliding adjust velocities
            var new_velocities = calculate_resulting_collision_velocities(self, other_body)
            velocity = new_velocities[0]
            other_body.velocity = new_velocities[1]
            
    
    var new_position = position + (velocity * delta)
    ## Bounce off walls
    if new_position.x + radius > universe.x_max || new_position.x - radius < 0:
        velocity.x = -velocity.x * universe.wall_cushion_factor
    if new_position.y + radius > universe.y_max || new_position.y - radius < 0:
        velocity.y = -velocity.y * universe.wall_cushion_factor
    position = new_position
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
    mass = m * 100
    radius = m / 2
    position = pos
    universe = u
    if position.x + radius > universe.x_max:
        position.x -= (position.x + radius) - universe.x_max
    if position.x - radius < universe.x_min:
        position.x -= (position.x - radius) - universe.x_min
    if position.y + radius > universe.y_max:
        position.y -= (position.y + radius) - universe.y_max
    if position.y - radius < universe.y_min:
        position.y -= (position.y - radius) - universe.y_min
    color = c
    velocity = v
    
func calculate_resulting_collision_velocities(body: MassiveBody, other_body: MassiveBody):
    var body_new_velocity : Vector2
    var other_body_new_velocity : Vector2
    body_new_velocity = (body.mass - other_body.mass) * (body.velocity) / (body.mass + other_body.mass) + (2 * other_body.mass) * (other_body.velocity) / (body.mass + other_body.mass)
    other_body_new_velocity = body.velocity + body_new_velocity - other_body.velocity
    return [body_new_velocity, other_body_new_velocity]
