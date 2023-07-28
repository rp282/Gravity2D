extends Camera2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    align(get_tree().get_first_node_in_group("universe"))

var zoom_speed = 0.1

func _input(event: InputEvent):
    if event.is_action("zoom_in"):
        zoom -= zoom * zoom_speed
    if event.is_action("zoom_out"):
        zoom += zoom * zoom_speed
