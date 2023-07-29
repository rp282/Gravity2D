class_name MassiveBody
extends Node2D


@export var mass : float
@export var glow_factor = 0.0001
var color : Color
var radius : float
var mesh : MeshInstance2D
var type : God.BodyTypes
var velocity : Vector2
var universe : Universe
var health = 5 

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
    
    var new_position = position + (velocity * delta)
    # Check for collisions
    for other_body in get_tree().get_nodes_in_group("bodies"):
        if other_body == self:
            continue
        if new_position.distance_to(other_body.position) < radius + other_body.radius: # Collision detected
            # if one of bodies is collider type
            if type == God.BodyTypes.elastic || other_body.type == God.BodyTypes.elastic:
                if type == God.BodyTypes.elastic:
                    health -= 1
                    if health <= 0:
                        type = God.BodyTypes.mergeable
                if other_body.type == God.BodyTypes.elastic:
                    other_body.health -= 1
                    if other_body.health <= 0:
                        other_body.type = God.BodyTypes.mergeable
                # Colliding adjust velocities
                var new_velocities = calculate_resulting_collision_velocities(self, other_body)
                velocity = new_velocities[0]
                other_body.velocity = new_velocities[1]
            else: # both are mergeable
                if mass >= other_body.mass:
                    velocity = (velocity * mass + other_body.velocity * other_body.mass) / (mass + other_body.mass)
                    color = calculate_new_color(self, other_body)
                    mass += other_body.mass
                    radius = calculate_radius(mass)
                    other_body.free()
                else:
                    other_body.velocity += (velocity * mass + other_body.velocity * other_body.mass) / (mass + other_body.mass)
                    color = calculate_new_color(self, other_body)
                    other_body.mass += mass
                    other_body.radius = calculate_radius(other_body.mass)
                    free()
                    return
    new_position = position + (velocity * delta)
    ## Bounce off walls
#    if new_position.x + radius > universe.x_max || new_position.x - radius < 0:
#        velocity.x = -velocity.x * universe.wall_cushion_factor
#    if new_position.y + radius > universe.y_max || new_position.y - radius < 0:
#        velocity.y = -velocity.y * universe.wall_cushion_factor
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
    match type:
        God.BodyTypes.elastic:
            draw_circle(Vector2(0,0), max(2, radius - 10), color.lightened(health * 0.1))
        God.BodyTypes.mergeable:
            draw_circle(Vector2(0,0), max(2, radius - 10), color.darkened(0.4))


func initialize(u: Universe, t: God.BodyTypes,  r: float, pos: Vector2, c: Color, v: Vector2 = Vector2(0, 0)):
    mass = calculate_mass(r)
    type = t
    radius = r
    position = pos
    universe = u
#    if position.x + radius > universe.x_max:
#        position.x -= (position.x + radius) - universe.x_max
#    if position.x - radius < universe.x_min:
#        position.x -= (position.x - radius) - universe.x_min
#    if position.y + radius > universe.y_max:
#        position.y -= (position.y + radius) - universe.y_max
#    if position.y - radius < universe.y_min:
#        position.y -= (position.y - radius) - universe.y_min
    color = c
    velocity = v
    

func calculate_mass(r: float):
    return 4.0 / 3.0 * PI * pow(r, 3)
    
const cube_root : float = 1.0 / 3.0
func calculate_radius(m: float):
    var r: float 
    var r1: float = 0.75 * m * PI
    r = pow(r1, cube_root)
    return r

    
func calculate_new_color(body, other_body):
    var rgb = Vector3(body.color.r, body.color.g, body.color.b)
    var other_rgb = Vector3(other_body.color.r, other_body.color.g, other_body.color.b)    
    var delta_rgb = other_rgb - rgb
    var result_rgb = rgb + other_body.mass / (mass + other_body.mass) * delta_rgb
    return Color(result_rgb.x, result_rgb.y, result_rgb.z)


func calculate_resulting_collision_velocities(body: MassiveBody, other_body: MassiveBody):
    var body_new_velocity : Vector2
    var other_body_new_velocity : Vector2
    body_new_velocity = (body.mass - other_body.mass) * (body.velocity) / (body.mass + other_body.mass) + (2 * other_body.mass) * (other_body.velocity) / (body.mass + other_body.mass)
    other_body_new_velocity = body.velocity + body_new_velocity - other_body.velocity
    return [body_new_velocity, other_body_new_velocity]
