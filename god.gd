extends Node

@export var universe : PackedScene
var current_universe : Universe
#var current_gravity : int = randi_range(0,100)
var current_gravity : float = 160
var large_bodies = 0
var small_bodies = 10


# Called when the node enters the scene tree for the first time.
func _ready():
    current_universe = universe.instantiate()
    current_universe.gravity = current_gravity
    current_universe.large_bodies = large_bodies
    current_universe.small_bodies = small_bodies
    add_child(current_universe)
    $InputLargeBodies.set_text(str(large_bodies))
    $InputSmallBodies.set_text(str(small_bodies))
    $InputG.set_text(str(current_gravity))
    
    $Background.size.x = ProjectSettings.get_setting("display/window/size/viewport_width")
    $Background.size.y = ProjectSettings.get_setting("display/window/size/viewport_height")

func _process(delta: float) -> void:
    $FPS.set_text("FPS %d" % Engine.get_frames_per_second())


func _input(event: InputEvent):
    if event.is_action_pressed("reset"):
        current_universe.queue_free()
        current_universe = universe.instantiate()
        current_universe.gravity = current_gravity
        current_universe.large_bodies = large_bodies
        current_universe.small_bodies = small_bodies
        add_child(current_universe)


func _on_input_large_bodies_text_changed(new_text):
    var val = int(new_text)
    large_bodies = val


func _on_input_small_bodies_text_changed(new_text):
    var val = int(new_text)
    small_bodies = val


func _on_input_g_text_changed(new_text):
    var val = int(new_text)
    current_gravity = val
