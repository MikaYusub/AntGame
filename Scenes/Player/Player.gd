extends CharacterBody2D

enum {
	MOVE,
	DAMAGE,
	DEATH,
	ACCELERATE,
	DEAD
}

signal health_changed(new_health)

var state = MOVE

@export var max_health = 120
var health

@export var max_stamina = 120
var stamina

var run_speed = 1
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED := 300.0


func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health
	stamina = max_stamina


func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		DAMAGE:
			handle_damage_state()
		DEATH:
			handle_death_state()
		DEAD:
			return

	move_and_slide()


func handle_damage_state():
	if state != DAMAGE:
		return
	velocity = Vector2.ZERO
	move_and_slide() # Apply zero velocity immediately
	anim.play("damage_taken")
	await anim.animation_finished
	state = MOVE

func handle_death_state():
	if state != DEATH:
		return

	velocity = Vector2.ZERO
	move_and_slide() # Apply zero velocity immediately

	anim.sprite_frames.set_animation_loop("death", false)
	anim.play("death")
	state = DEAD

	await anim.animation_finished

	anim.pause()
	

func move_state():
	anim.play("jetpack")
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

	if Input.is_action_pressed("sprint") and stamina > 0:
		run_speed = 2
		stamina -= 1
	else:
		run_speed = 1
		stamina += 1

	Signals.emit_signal("player_stamina_changed", stamina)


func _on_damage_received(enemy_damage):
	if health <= 0:
		return

	health -= enemy_damage
	
	if health <= 0:
		health = 0
		state = DEATH
	else:
		state = DAMAGE

	Signals.emit_signal("player_health_changed", health)
	velocity = Vector2.ZERO
