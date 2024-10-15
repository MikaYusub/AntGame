# MainMenu.gd
extends Control

func _ready():
    # Connect to the SettingsManager signals
    SettingsManager.connect("settings_closed", Callable(self, "_on_settings_closed"))
    SettingsManager.connect("settings_opened", Callable(self, "_on_settings_opened"))
    print("MainMenu ready.")

func _on_exit_pressed():
    get_tree().quit()

func _on_easy_button_pressed():
    SharedVariables.player_health = 150
    SharedVariables.player_stamina = 150
    SharedVariables.player_speed = 350
    SharedVariables.enemy_speed = 500
    SharedVariables.enemy_acceleration = 5

    get_tree().change_scene_to_file("res://Scenes/Level/Level.tscn")

func _on_medium_button_pressed():
    SharedVariables.player_health = 120
    SharedVariables.player_stamina = 120
    SharedVariables.player_speed = 300
    SharedVariables.enemy_speed = 750
    SharedVariables.enemy_acceleration = 10

    get_tree().change_scene_to_file("res://Scenes/Level/Level.tscn")

func _on_hard_button_pressed():
    SharedVariables.player_health = 80
    SharedVariables.player_stamina = 80
    SharedVariables.player_speed = 250
    SharedVariables.enemy_speed = 1000
    SharedVariables.enemy_acceleration = 20
    SharedVariables.enemy_scale_addition = 0.03
    SharedVariables.enemy_timer_decay = 0.03

    get_tree().change_scene_to_file("res://Scenes/Level/Level.tscn")

func _on_options_pressed() -> void:
    SettingsManager.open_settings_menu(self)  # Open SettingsMenu via singleton
    print("MainMenu: Options pressed, opening settings.")

func _on_settings_closed() -> void:
    print("MainMenu: settings_closed signal received.")
    visible = true  # Show the MainMenu when settings are closed

func _on_settings_opened() -> void:
    print("MainMenu: settings_opened signal received.")
    visible = false  # Hide the MainMenu when settings are opened
