extends Area2D

class_name Player

signal hit
signal shooting

export(PackedScene) var fist_scene

export var speed = 400
var screen_size
var is_shooting = false
var fist: Fist
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
	
	if Input.is_action_pressed("shoot_right") or Input.is_action_pressed("shoot_down") or Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_up"):
		if !fist: 
			emit_signal("shooting")
			
	if velocity.x != 0:
		if is_shooting:
			$AnimatedSprite.animation = "walk_shoot"
		else:
			$AnimatedSprite.animation = "walk"
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


func _on_Player_shooting():
	is_shooting = true
	$AnimatedSprite.animation = "walk_shoot"
	fist = fist_scene.instance()
	add_child(fist)
