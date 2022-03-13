extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animated_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	animated_sprite = get_node("AnimatedSprite")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
		


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
