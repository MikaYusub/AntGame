# PauseMenu.gd
extends Control

var _is_paused: bool = false:
    set(value):
        _is_paused = value
        get_tree().paused = _is_paused
        visible = _is_paused

func _ready():
    # Connect to the SettingsManager signals
    SettingsManager.connect("settings_closed", Callable(self, "_on_settings_closed"))
    SettingsManager.connect("settings_opened", Callable(self, "_on_settings_opened"))

func _unhandled_input(event: InputEvent) -> void:
    # Prevent opening PauseMenu if SettingsMenu is open
    if SettingsManager.is_settings_open():
        return

    # Toggle pause state when "pause" action is pressed
    if event.is_action_pressed("pause"):
        _is_paused = !_is_paused
        visible = _is_paused
        get_tree().paused = _is_paused  # Ensure the game pauses/unpauses correctly

func _on_quit_pressed() -> void:
    get_tree().quit()

func _on_restart_pressed() -> void:
    _is_paused = false
    get_tree().paused = false

    get_tree().reload_current_scene()

func _on_resume_pressed() -> void:
    _is_paused = false
    visible = false

func _on_options_pressed() -> void:
    SettingsManager.open_settings_menu(self)  # Open SettingsMenu via singleton
    print("PauseMenu: Options pressed, opening settings.")

func _on_settings_closed() -> void:
    _is_paused = true  # Ensure the game stays paused
    get_tree().paused = true  # Ensure the game is still paused
    visible = true  # Show the PauseMenu when settings are closed

func _on_settings_opened() -> void:
    print("PauseMenu: settings_opened signal received.")
    visible = false  # Hide the PauseMenu when settings are opened
