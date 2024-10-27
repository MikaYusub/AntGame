extends Node

var player_health: int = 120
var player_stamina: int = 120
var player_speed: int = 300
var enemy_speed: int = 750
var enemy_acceleration: int = 10
var enemy_scale_addition: float = 0.01
var enemy_timer_decay: float = 0.01

var enemy_speed_adjust_ratio: float = 0.75 # reduse coming from top or bottom of the screen enemies speed 