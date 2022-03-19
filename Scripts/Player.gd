extends Area2D

class_name Player

signal dead
signal hit
export var speed: int = 400
var screen_size: Vector2
var damage: int = 2
var health: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	if health <= 0:
		hide()
		emit_signal("dead")
		$CollisionShape2D.set_deferred("disabled", true)
		
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
			
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk_shoot"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.frame = 0

func _on_Player_body_entered(body):
	if body is Enemy:
		emit_signal("hit")
		health -= body.damage
		body.health -= damage

func start(pos):
	position = pos
	health = 3
	show()
	$CollisionShape2D.disabled = false
