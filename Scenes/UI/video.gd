extends TabBar

func _ready() -> void:
    var screen_type = Persistence.config.get_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)
    if screen_type == DisplayServer.WINDOW_MODE_FULLSCREEN:
        %Fullscreen.button_pressed = true

    var borderless_type = Persistence.config.get_value("Video", "borderless", false)
    if borderless_type:
        %Borderless.button_pressed = true

    var vsync_index = Persistence.config.get_value("Video", "vsync", 0)
    %Vsync.selected = vsync_index 


func _on_fullscreen_toggled(toggled_on:bool) -> void:
    if toggled_on:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        Persistence.config.set_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        Persistence.config.set_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)

    Persistence.save_data()

func _on_borderless_toggled(toggled_on:bool) -> void:
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
    Persistence.config.set_value("Video", "borderless", toggled_on)
    Persistence.save_data()

func _on_vsync_item_selected(index:int) -> void:
    DisplayServer.window_set_vsync_mode(index)
    Persistence.config.set_value("Video", "vsync", index)
    Persistence.save_data()