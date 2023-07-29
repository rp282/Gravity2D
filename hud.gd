class_name HUD
extends CanvasLayer


var current_god : God


func update(god: God):
    current_god = god
    $InputG.set_text(str(god.current_gravity))
    $InputLargeBodies.set_text(str(god.large_bodies))
    $InputSmallBodies.set_text(str(god.small_bodies))
    $InputSpawnAreaSize.set_text(str(god.spawn_area_size))
    $TotalMass.set_text("Total Mass: " + format(god.current_universe.total_mass))


func _input(event: InputEvent):
    if event.is_action("reset"):
        for input in get_tree().get_nodes_in_group("line_edits"):
            input.release_focus()


func format(n):
    n = str(int(n))
    var size = n.length()
    var s = ""

    for i in range(size):
        if((size - i) % 3 == 0 and i > 0):
            s = str(s,",", n[i])
        else:
            s = str(s,n[i])
    return s


func _process(_delta: float) -> void:
    $FPS.set_text("FPS %d" % Engine.get_frames_per_second())


func _on_input_large_bodies_text_changed(new_text):
    var val = int(new_text)
    current_god.large_bodies = val


func _on_input_small_bodies_text_changed(new_text):
    var val = int(new_text)
    current_god.small_bodies = val


func _on_input_g_text_changed(new_text):
    var val = float(new_text)
    current_god.current_gravity = val


func _on_input_spawn_area_size_text_changed(new_text):
    var val = float(new_text)
    current_god.spawn_area_size = val
