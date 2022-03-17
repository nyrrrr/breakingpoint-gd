extends Node

class_name Fist

export var speed = 600
var screen_size
var starting_position: Vector2
var velocity: Vector2
var is_returning: bool
var player

var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_parent().get_viewport().size
	player = get_parent().get_node("Player/FistReturnPosition")
	starting_position = player.position
	self.position = player.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("shoot_left") and is_returning == false:
		velocity.x -= 1
	if Input.is_action_pressed("shoot_right") and is_returning == false:
		velocity.x += 1
	if Input.is_action_pressed("shoot_up") and is_returning == false:
		velocity.y -= 1
	if Input.is_action_pressed("shoot_down") and is_returning == false:
		velocity.y += 1
	if is_returning or (!Input.is_action_pressed("shoot_left") && !Input.is_action_pressed("shoot_right") && !Input.is_action_pressed("shoot_up") && !Input.is_action_pressed("shoot_down")):
		is_returning = true
		velocity = player.global_position - self.global_position
		if velocity.length() < 5:
			velocity = Vector2.ZERO
			self.position = player.global_position
			is_returning = false
	velocity = velocity.normalized() * speed
	self.global_position += velocity * delta
	self.global_position.x = clamp(self.global_position.x, 0, screen_size.x)
	self.global_position.y = clamp(self.global_position.y, 0, screen_size.y)

func _on_Fist_body_entered(body):
	if body is Enemy:
		body.health -= damage
		is_returning = true
		# bounce the enemy back
		var old_lin_velocity = body.linear_velocity
		body.linear_velocity = velocity / speed
		body.get_node("CollisionShape2D").set_deferred("disabled", true)
		yield(get_tree().create_timer(1.0), "timeout")
		if is_instance_valid(body): 
			body.get_node("CollisionShape2D").disabled = false
			body.linear_velocity = old_lin_velocity
		
		
func start(pos):
	self.position = pos
	$CollisionShape2D.disabled = false
