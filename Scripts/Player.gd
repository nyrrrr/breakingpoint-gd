extends Area2D

class_name Player

signal hit

export var speed = 400
var screen_size
var damage = 2
var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()


func _process(delta):
	if health <= 0:
		hide()
		emit_signal("hit")
		
	var velocity = Vector2.ZERO # The player's movement vector.
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
		health -= body.damage
		body.health -= damage

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
