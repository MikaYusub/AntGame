extends CharacterBody2D

enum {
	MOVE,
	DAMAGE,
	DEATH,
	ACCELERATE
}

signal health_changed(new_health)

var state = MOVE

var max_health = 120
var health

var max_stamina = 120
var stamina

var run_speed = 1
@onready var anim = $AnimatedSprite2D

@export var SPEED := 300.0


func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health


func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		DAMAGE:
			# logic here
			state = MOVE

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

func _on_damage_received(enemy_damage):
	health -= enemy_damage
	
	if health <= 0:
		health = 0
		state = DEATH
	else:
		state = DAMAGE

	Signals.emit_signal("player_health_changed", health)