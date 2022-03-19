extends KinematicBody2D

class_name Pet

signal score_up

export var speed: int = 600
export var acceleration: int = 18500
export var return_acceleration: int = 10000
export var max_distance: int = 500
export var max_total_flight_distance: int = 60000

var screen_size

var starting_position: Vector2
var velocity: Vector2
var distance_to_player: float
var distance_passed: float
var collision: KinematicCollision2D = null

var is_returning: bool
var player

var damage: int = 1

func _ready():
	screen_size = get_parent().get_viewport().size
	player = get_parent().get_node("Player/PetReturnPosition")
	starting_position = player.position
	self.position = player.global_position

func _physics_process (delta):
	collision = null
	velocity = Vector2.ZERO
	distance_to_player = (player.global_position - self.global_position).length()
	if distance_to_player > max_distance:
		is_returning = true
	if Input.is_action_pressed("shoot_left") and is_returning == false:
		velocity.x -= 1
	elif Input.is_action_pressed("shoot_right") and is_returning == false:
		velocity.x += 1
	if Input.is_action_pressed("shoot_up") and is_returning == false:
		velocity.y -= 1
	elif Input.is_action_pressed("shoot_down") and is_returning == false:
		velocity.y += 1
	if is_returning or (!Input.is_action_pressed("shoot_left") && !Input.is_action_pressed("shoot_right") && !Input.is_action_pressed("shoot_up") && !Input.is_action_pressed("shoot_down")):
		is_returning = true
		velocity = player.global_position - self.global_position
		if velocity.length() < 5:
			velocity = Vector2.ZERO
			self.position = player.global_position
			is_returning = false
			distance_passed = 0
	velocity = velocity.move_toward(velocity.normalized() * speed, (return_acceleration if is_returning else acceleration) * delta)
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.flip_h = velocity.x > 0
	distance_passed += velocity.length()
	if distance_passed > max_total_flight_distance:
		is_returning = true
#	self.global_position += velocity * delta
#	velocity = move_and_slide(velocity)
	collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.collider.name)
	self.global_position.x = clamp(self.global_position.x, 0, screen_size.x)
	self.global_position.y = clamp(self.global_position.y, 0, screen_size.y)

#func _on_Fist_body_entered(body):
#	if body is Enemy:
#		body.health -= damage
#		is_returning = true
#		emit_signal("score_up")
#		print("emit")
#		var old_lin_velocity = body.linear_velocity
#		body.linear_velocity = velocity / 100000
#		body.get_node("CollisionShape2D").set_deferred("disabled", true)
#		yield(get_tree().create_timer(1.0), "timeout")
#		if is_instance_valid(body): 
#			body.get_node("CollisionShape2D").disabled = false
#			body.linear_velocity = old_lin_velocity
		
func start(pos):
	self.position = pos
	$CollisionShape2D.disabled = false
