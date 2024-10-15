extends Control

func _on_back_button_pressed() -> void:
    print("SettingsMenu: Back button pressed.")
    SettingsManager.close_settings_menu()  # Close SettingsMenu via singleton

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):  # Check if the Esc key (ui_cancel) is pressed
        _on_back_button_pressed()  # Call the back button function
