extends Node2D

@onready var healthBar = $CanvasLayer/HealthBar
@onready var staminaBar = $CanvasLayer/StaminaBar
@onready var player = $Player
@onready var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")
@onready var time = $CanvasLayer/Score
@onready var timer = $Timer


@export var enemy_speed: float = 500
@export var enemy_scale: float = 3
@export var enemy_acceleration: float = 10
@export var enemy_timer_decay: float = 0.01

func _ready():
    Signals.connect("player_health_changed", Callable(self, "_on_player_health_changed"))
    healthBar.max_value = player.max_health
    healthBar.value = healthBar.max_value

    staminaBar.max_value = player.max_stamina
    staminaBar.value = staminaBar.max_value

func _process(delta):
    time.text = "Score: " + str(Time.get_ticks_msec() / 1000.0)

    enemy_speed += enemy_acceleration * delta
    timer.wait_time -= enemy_timer_decay * delta

#test spawn enemy button for development
func _on_button_pressed():
    var enemy_instance = enemy_scene.instantiate()
    enemy_instance.speed = enemy_speed
    enemy_instance.scale = Vector2(enemy_scale, enemy_scale)
    add_child(enemy_instance)
    enemy_instance.spawn_enemy()


func _on_player_health_changed(new_health):
    healthBar.value = new_health


func _on_enemy_timeout():
    var enemy_instance = enemy_scene.instantiate()
    enemy_instance.speed = enemy_speed
    enemy_instance.scale = Vector2(enemy_scale, enemy_scale)
    add_child(enemy_instance)
    enemy_instance.spawn_enemy()
