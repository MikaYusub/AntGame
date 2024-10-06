extends Node2D

var start_point: Vector2
var end_point: Vector2
var extended_end_point: Vector2

var speed: float = 500

@onready var camera: Camera2D = get_node("/root/Level/Player/PlayerCamera")
var damage: float = 10
@onready var viewport_rect = get_viewport_rect()

func _ready():
	randomize()
	# camera.make_current()

func _physics_process(_delta):
	var direction = start_point.direction_to(end_point)

	if position.distance_to(end_point) > 1:
		position += direction * speed * _delta
	else:
		position = end_point
		queue_free()


func get_camera_rect() -> Rect2:
	var pos = camera.get_target_position() # Camera's center
	var half_size = camera.get_viewport_rect().size * 0.5
	var res = Rect2(pos - half_size, half_size * 2)
	return res


func spawn_enemy():
	choose_random_points(get_camera_rect())
	position = start_point
	rotation = start_point.angle_to_point(end_point) + PI / 2

	# choose_random_points(viewport_rect)
	# queue_redraw()

func choose_random_points(play_area: Rect2):
	start_point = get_random_point_outside_viewport(play_area)
	end_point = get_random_point_inside_viewport(play_area)
	var direction = (end_point - start_point).normalized()
	var extended_lenght = 22000
	extended_end_point = start_point + direction * extended_lenght


func get_random_point_outside_viewport(play_area: Rect2) -> Vector2:
	var rand_choice = randi() % 4 # 0 = top, 1 = right, 2 = bottom, 3 = left
	var margin = 100

	match rand_choice:
		0: # Top (x can vary, y is always negative)
			return Vector2(rand_range(play_area.position.x - margin, play_area.position.x + play_area.size.x + margin), play_area.position.y - margin)
		1: # Right (x is outside the right side, y can vary)
			return Vector2(play_area.position.x + play_area.size.x + margin, rand_range(play_area.position.y - margin, play_area.position.y + play_area.size.y + margin))
		2: # Bottom (x can vary, y is outside the bottom side)
			return Vector2(rand_range(play_area.position.x - margin, play_area.position.x + play_area.size.x + margin), play_area.position.y + play_area.size.y + margin)
		3: # Left (x is negative, y can vary)
			return Vector2(play_area.position.x - margin, rand_range(play_area.position.y - margin, play_area.position.y + play_area.size.y + margin))
	
	return Vector2(0, 0)

func get_random_point_inside_viewport(play_area: Rect2) -> Vector2:
	var margin = 20
	var min_x = play_area.position.x + margin
	var max_x = play_area.position.x + play_area.size.x - margin
	var min_y = play_area.position.y + margin
	var max_y = play_area.position.y + play_area.size.y - margin

	return Vector2(rand_range(min_x, max_x), rand_range(min_y, max_y))


func rand_range(min_val: float, max_val: float) -> float:
	return lerp(min_val, max_val, randf())

func _on_area_2d_body_entered(_body: Node2D):
	Signals.emit_signal("enemy_attack", damage)
	print("Enemy collided with: ", _body)
