extends Node

export(PackedScene) var enemy_scene

func _ready():
	randomize()
	new_game()

func game_over():
	$EnemyTimer.stop()
	
func new_game():
	$Player.start($StartPosition.position)
	$Fist.start($Player/FistReturnPosition.global_position)
	$StartTimer.start()

func _on_EnemyTimer_timeout():
	var spawn_location = get_node("EnemyPath/EnemySpawnLocation")
	spawn_location.offset = randi()
	
	var enemy = enemy_scene.instance()
	add_child(enemy)
	
	var direction = spawn_location.rotation + PI / 2
	enemy.position = spawn_location.position

	direction += rand_range(-PI / 4, PI / 4)
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	enemy.animated_sprite.flip_h = enemy.linear_velocity.x < 0


func _on_StartTimer_timeout():
	$EnemyTimer.start()
