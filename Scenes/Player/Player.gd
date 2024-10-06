extends CharacterBody2D

enum {
	MOVE,
	DAMAGE,
	DEATH,
	ACCELERATE
}

var state = MOVE

var max_health = 120
var health

var max_stamina = 120
var stamina

var run_speed = 1
@onready var anim = $Sprite2D

@export var SPEED := 300.0
func _ready():
	# Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health


func _physics_process(delta):
	match state:
		MOVE:
			move_state()

	move_and_slide()

func move_state():
	velocity = Vector2.ZERO

	if Input.is_action_pressed("right"):
		velocity.x += SPEED * run_speed
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED * run_speed
	if Input.is_action_pressed("down"):
		velocity.y += SPEED * run_speed
	if Input.is_action_pressed("up"):
		velocity.y -= SPEED * run_speed
	
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * SPEED * run_speed

	var direction = Input.get_axis("left", "right")

	if direction == -1:
		anim.flip_h = false
	elif direction == 1:
		anim.flip_h = true

	if Input.is_action_pressed("sprint"):
		run_speed = 2 
	else:
		run_speed = 1
