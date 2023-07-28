class_name Universe
extends Node2D

@export var gravity : float
@export var massive_body : PackedScene

var massive_objects : Array[MassiveBody] = []
var x_max = ProjectSettings.get_setting("display/window/size/viewport_width")
var x_min = 0
var y_max = ProjectSettings.get_setting("display/window/size/viewport_height")
var y_min = 0

var small_bodies : int
var large_bodies : int

var wall_cushion_factor : float = 1 ## amount walls decelerate bodies on impact

var velocity = Vector2.ZERO

func _ready():
    print(gravity)
    ## Large body
    for i in large_bodies:
        var generated_mass = randf_range(80,140)
        var random_position = Vector2(randf_range(0, x_max), randf_range(0, y_max))
        var body : MassiveBody = massive_body.instantiate()
        body.initialize(self, generated_mass, random_position, Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1))
#        var body = MassiveBody.new(generated_mass, random_position, Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1))
        massive_objects.push_back(body)
        add_child(body)
    ## Small bodies
    for i in small_bodies:
        var generated_mass = randf_range(3,45)
        var random_position = Vector2(randf_range(0, x_max), randf_range(0, y_max))
        var body : MassiveBody = massive_body.instantiate()
        body.initialize(self, generated_mass, random_position, Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1))
#        var body = MassiveBody.new(generated_mass, random_position, Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1))
        massive_objects.push_back(body)
        add_child(body)


#func _process(delta):
#    for body in massive_objects:
#        var velocity = Vector2(0, 0)
#        for other_body in massive_objects:
#            if other_body == body:
#                continue
#            var f = gravity * body.mass * other_body.mass / body.position.distance_squared_to(other_body.position)
#            var direction = (other_body.position - body.position).normalized()
#            velocity += f * direction
#        body.velocity += velocity / body.mass
#    pass
