# SettingsManager.gd
extends Node

# Signals to notify when settings are opened or closed
signal settings_opened
signal settings_closed

# Path to the SettingsMenu scene
var settings_scene_path = "res://Scenes/UI/settings.tscn"
var settings_menu = null
var active_menu = null
var settings_open = false  # Tracks if settings are currently open

func _ready():
    # Instantiate and add SettingsMenu to the scene tree if not already present
    if not settings_menu:
        settings_menu = load(settings_scene_path).instantiate()
        get_tree().root.add_child(settings_menu)
        settings_menu.hide()
    print("SettingsManager ready. Settings menu loaded and hidden.")

# Helper function to recursively set visibility of child nodes
func set_visibility_recursive(node: Node, visibility: bool) -> void:
    if node is CanvasItem:
        node.visible = visibility
    for child in node.get_children():
        set_visibility_recursive(child, visibility)

# Function to open the SettingsMenu
func open_settings_menu(menu):
    print("SettingsManager: Opening settings menu from ", menu.name)
    if settings_menu:
        if settings_menu.get_parent() == null:
            get_tree().root.add_child(settings_menu)  # Ensure it's added to the root if it got unloaded

        active_menu = menu
        active_menu.visible = false  # Hide the active menu (MainMenu or PauseMenu)

        # Make sure SettingsMenu and its children are visible
        set_visibility_recursive(settings_menu, true)
        settings_open = true  # Mark that settings are open

        emit_signal("settings_opened")  # Notify that settings have been opened

# Function to close the SettingsMenu
func close_settings_menu():
    print("SettingsManager: Closing settings menu.")
    if settings_menu:
        # Hide the SettingsMenu and its children
        set_visibility_recursive(settings_menu, false)
        settings_menu.hide()

        # Restore visibility of the active menu
        if active_menu:
            set_visibility_recursive(active_menu, true)

        active_menu = null  # Reset the active menu

        settings_open = false  # Mark that settings are closed

        emit_signal("settings_closed")  # Notify that settings have been closed

# Function to check if SettingsMenu is currently open
func is_settings_open() -> bool:
    return settings_open
