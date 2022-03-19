extends Node

class_name Enemy

var health: int = 2
var animated_sprite: AnimatedSprite
var damage: int = 1

func _ready():
	$AnimatedSprite.playing = true
	animated_sprite = get_node("AnimatedSprite")
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if health <= 0:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Enemy_body_entered(body):
	damage = 0
	if body is Pet:
		health -= body.damage
		body.is_returning = true
		emit_signal("score_up")
		$CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(0.1), "timeout")
		if is_instance_valid(self): 
			$CollisionShape2D.disabled = false
