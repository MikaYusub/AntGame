extends Node2D

@onready var healthBar = $CanvasLayer/HealthBar
@onready var staminaBar = $CanvasLayer/StaminaBar
@onready var player = $Player
@onready var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")

@export var enemy_speed: float = 500
@export var enemy_scale: float = 3

func _ready():
    Signals.connect("player_health_changed", Callable(self, "_on_player_health_changed"))
    healthBar.max_value = player.max_health
    healthBar.value = healthBar.max_value

    staminaBar.max_value = player.max_stamina
    staminaBar.value = staminaBar.max_value


#test spawn enemy button for development
func _on_button_pressed():
    var enemy_instance = enemy_scene.instantiate()
    enemy_instance.speed = enemy_speed
    enemy_instance.scale = Vector2(enemy_scale, enemy_scale)
    add_child(enemy_instance)
    enemy_instance.spawn_enemy()


func _on_player_health_changed(new_health):
    print("Player health changed: ", new_health)
    healthBar.value = new_health


func _on_enemy_timeout():
    var enemy_instance = enemy_scene.instantiate()
    enemy_instance.speed = enemy_speed
    enemy_instance.scale = Vector2(enemy_scale, enemy_scale)
    add_child(enemy_instance)
    enemy_instance.spawn_enemy()
