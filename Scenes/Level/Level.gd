extends Node2D

@onready var healthBar = $CanvasLayer/HealthBar
@onready var staminaBar = $CanvasLayer/StaminaBar
@onready var player = $Player

func _ready():
    healthBar.max_value = player.max_health
    healthBar.value = healthBar.max_value

    staminaBar.max_value = player.max_stamina
    staminaBar.value = staminaBar.max_value


# func _on_player_health_changed(new_health:Variant):
# 	healthBar.value = new_health
