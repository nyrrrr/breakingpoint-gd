extends Area2D
signal hit

export(PackedScene) var fist_scene

export var speed = 400
var screen_size
var is_shooting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()


func _process(delta):
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
		is_shooting = true
		var fist = fist_scene.instance()
		add_child(fist)
		fist.position = $FistPosition.position
		
	if velocity.x != 0:
		if is_shooting:
			$AnimatedSprite.animation = "walk_shoot"
		else:
			$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0

func _on_Player_body_entered(body):
	if body.get_name().find("Fist") != -1: 
		is_shooting = false
		$AnimatedSprite.animation = "walk"
		body.queue_free()
	else: 	
		hide()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
