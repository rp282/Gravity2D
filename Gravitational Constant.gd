extends Label


func _process(delta: float) -> void:
    set_text("G: %d" % get_parent().current_gravity)
