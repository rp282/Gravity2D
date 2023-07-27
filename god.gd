extends Node

@export var universe : PackedScene
var current_universe : Node

# Called when the node enters the scene tree for the first time.
func _ready():
    current_universe = universe.instantiate()
    add_child(current_universe)
    pass # Replace with function body.


func _input(event: InputEvent):
    if event.is_action_pressed("reset"):
        current_universe.queue_free()
        current_universe = universe.instantiate()
        add_child(current_universe)
