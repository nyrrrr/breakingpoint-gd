extends Node

class_name Fist

export var speed = 600
var screen_size
var starting_position: Vector2
var velocity: Vector2

var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_parent().get_viewport().size
	starting_position = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("shoot_left"):
		velocity.x -= 1
	if Input.is_action_pressed("shoot_right"):
		velocity.x += 1
	if Input.is_action_pressed("shoot_up"):
		velocity.y -= 1
	if Input.is_action_pressed("shoot_down"):
		velocity.y += 1
	if !Input.is_action_pressed("shoot_left") && !Input.is_action_pressed("shoot_right") && !Input.is_action_pressed("shoot_up") && !Input.is_action_pressed("shoot_down"):
		velocity = starting_position - self.position
		if velocity.length() < 10:
			velocity = Vector2.ZERO
	velocity = velocity.normalized() * speed
	self.global_position += velocity * delta
	self.global_position.x = clamp(self.global_position.x, 0, screen_size.x)
	self.global_position.y = clamp(self.global_position.y, 0, screen_size.y)

func _on_Fist_body_entered(body):
	if body is Enemy:
		body.health -= damage
		# bounce the enemy back
