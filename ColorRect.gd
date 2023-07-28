extends ColorRect


func _ready():
    size.x = ProjectSettings.get_setting("display/window/size/viewport_width")
    size.y = ProjectSettings.get_setting("display/window/size/viewport_height")

