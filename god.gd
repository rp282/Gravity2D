extends Node

@export var universe : PackedScene
var current_universe : Universe
var current_gravity : int = randi_range(0,100)
var large_bodies = 1
var small_bodies = 15


# Called when the node enters the scene tree for the first time.
func _ready():
    current_universe = universe.instantiate()
    current_universe.gravity = current_gravity
    add_child(current_universe)
    $InputLargeBodies.set_text(str(large_bodies))
    $InputSmallBodies.set_text(str(small_bodies))
    pass # Replace with function body.


func _input(event: InputEvent):
    if event.is_action_pressed("reset"):
        current_universe.queue_free()
        current_universe = universe.instantiate()
        current_gravity = randi_range(0,100)
        current_universe.large_bodies = large_bodies
        current_universe.small_bodies = small_bodies
        add_child(current_universe)


func _on_input_large_bodies_text_changed(new_text):
    var val = int(new_text)
    $InputLargeBodies.set_text(str(val))
    large_bodies = val

func _on_input_small_bodies_text_changed(new_text):
    var val = int(new_text)
    $InputSmallBodies.set_text(str(val))
    small_bodies = val
