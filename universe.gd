class_name Universe
extends Node2D

@export var gravity : float
@export var massive_body : PackedScene

#var massive_objects : Array[MassiveBody] = []
#var x_max = ProjectSettings.get_setting("display/window/size/viewport_width")
#var x_min = -ProjectSettings.get_setting("display/window/size/viewport_width")
var y_max = ProjectSettings.get_setting("display/window/size/viewport_height")
var y_min = -ProjectSettings.get_setting("display/window/size/viewport_height")
var x_max = y_max
var x_min = y_min

var small_bodies : int
var large_bodies : int

var wall_cushion_factor : float = 1 ## amount walls decelerate bodies on impact

var velocity = Vector2.ZERO

var total_mass : float = 0
var center_of_mass : Vector2

var spawn_area_size = 1

func _ready():
    ## Large body
    for i in large_bodies:
        var random_radius = randf_range(50,120)
        var random_position = Vector2(randf_range(spawn_area_size * x_min, spawn_area_size * x_max), randf_range(spawn_area_size * y_min, spawn_area_size * y_max))
        var body : MassiveBody = massive_body.instantiate()
        body.initialize(self, randi() % God.BodyTypes.size(), random_radius, random_position, Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1))
        total_mass += body.mass
        add_child(body)
    ## Small bodies
    for i in small_bodies:
        var random_radius = randf_range(6,13) 
        var random_position = Vector2(randf_range(spawn_area_size * x_min, spawn_area_size * x_max), randf_range(spawn_area_size * y_min, spawn_area_size * y_max))
        var body : MassiveBody = massive_body.instantiate()
        body.initialize(self, randi() % God.BodyTypes.size(), random_radius, random_position, Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1))
        total_mass += body.mass
        add_child(body)

var test_tick: float  = 0
func _process(delta):
    test_tick += delta
    var c = Vector2.ZERO # center of mass
    var m = 0 # mass
    for body in get_tree().get_nodes_in_group("bodies"): # Replace with get only bodies in own chunk
        c = (c * m + body.position * body.mass) / (m + body.mass)
        m += body.mass
    center_of_mass = c
    $COM1.position = center_of_mass
    if test_tick > 0.33:
        test_tick = 0
        c = Vector2.ZERO # center of mass
        m = 0 # mass
        for body in get_tree().get_nodes_in_group("bodies"): # Replace with get only bodies in own chunk
            c = (c * m + body.position * body.mass) / (m + body.mass)
            m += body.mass
        $COM2.position = center_of_mass
        
