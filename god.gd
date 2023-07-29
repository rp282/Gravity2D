class_name God
extends Camera2D


@export var hud_scene : PackedScene


enum BodyTypes { elastic, mergeable }


# Universal constants
@export var universe : PackedScene
var current_universe : Universe = null
var current_gravity : float = 740
var large_bodies = 55
var small_bodies = 45
var spawn_area_size = 45

# Camera Variables
var zoom_speed = 0.1
var panning = false


var hud : HUD


func zoom_camera(zoom_factor, mouse_position):
    var viewport_size = get_viewport().size
    var previous_zoom = zoom
    zoom += zoom * zoom_factor
    offset += ((viewport_size * 0.5) - mouse_position) * (zoom-previous_zoom)


func _ready():
    zoom = Vector2(0.027813, 0.027813)
    RenderingServer.set_default_clear_color(Color.BLACK)
    spawn_universe()
    
    hud = hud_scene.instantiate()
    hud.update(self)
    add_child(hud)


func _input(event: InputEvent):
    if event.is_action_released('escape'):
        get_tree().quit()
    if event.is_action_pressed("reset"):
        offset = Vector2(0, 0)
        zoom = Vector2(0.027813, 0.027813)
        spawn_universe()
        hud.update(self)
    if event.is_action_released('zoom_in'):
        zoom_camera(-zoom_speed, event.position)
    if event.is_action_released('zoom_out'):
        zoom_camera(zoom_speed, event.position)
    if event.is_action_pressed("pan_with_mouse"):
        panning = true
    elif event.is_action_released("pan_with_mouse"):
        panning = false
    if event is InputEventMouseMotion and panning == true:
        offset -= event.relative / zoom


func spawn_universe():
    if current_universe != null:
        current_universe.queue_free()
    current_universe = universe.instantiate()
    current_universe.gravity = current_gravity
    current_universe.large_bodies = large_bodies
    current_universe.small_bodies = small_bodies
    current_universe.spawn_area_size = spawn_area_size
    add_child(current_universe)
