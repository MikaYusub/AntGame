extends Node2D

class_name Level


@onready var healthBar = $UI/CanvasLayer/HealthBar
@onready var staminaBar = $UI/CanvasLayer/StaminaBar
@onready var player = $Player
@onready var enemy_scene = load("res://Scenes/Enemy/enemy.tscn")
@onready var time = $UI/CanvasLayer/Score
@onready var timer = $Timer

@onready var gameOverMenu = $GameOverMenu
@onready var gameOverScoreLabel = $GameOverMenu/CenterContainer/VBoxContainer/ScoreLabel

var enemy_speed: float = SharedVariables.enemy_speed
var enemy_acceleration: float = SharedVariables.enemy_acceleration
var enemy_scale_addition: float = SharedVariables.enemy_scale_addition
var enemy_timer_decay: float = SharedVariables.enemy_timer_decay

@export var enemy_scale: float = 3

var score: float = 0
var start_time: int = 0

func _ready():
	start_time = Time.get_ticks_msec()

	Signals.connect("player_health_changed", Callable(self, "_on_player_health_changed"))
	Signals.connect("player_stamina_changed", Callable(self, "_on_player_stamina_changed"))
	healthBar.max_value = player.max_health
	healthBar.value = healthBar.max_value

	staminaBar.max_value = player.max_stamina
	staminaBar.value = staminaBar.max_value

func _process(delta):
	if healthBar.value > 0:
		score = (Time.get_ticks_msec() - start_time) / 1000.0;

	time.text = "Score: " + str(score)

	enemy_speed += enemy_acceleration * delta
	enemy_scale += enemy_scale_addition * delta
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

	if new_health <= 0:
		gameOverScoreLabel.text += str(score)

		gameOverMenu.show()


func _on_player_stamina_changed(new_stamina):
	staminaBar.value = new_stamina


func _on_enemy_timeout():
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.speed = enemy_speed
	enemy_instance.scale = Vector2(enemy_scale, enemy_scale)
	add_child(enemy_instance)
	enemy_instance.spawn_enemy()

# Game Over Menu TODO refactor to separate script
func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level/MainMenu.tscn")	