class_name EnemySpawner
extends Spawner

signal all_spawned_enemies_killed

@onready var color_rect: ColorRect = $ColorRect
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pentagram_light: PointLight2D = $PentagramLight
@onready var normal_light: PointLight2D = $NormalLight

# Tweens
var pentagram_light_tween: Tween
var pentagram_rotate_tween: Tween

# Tracking enemies alive/dead
var spawned_enemies_killed: int = 0 :
	set(value):
		spawned_enemies_killed = value
		if spawned_enemies_killed >= total_elements_to_spawn:
			all_elements_destroyed()

func _ready() -> void:
	animated_sprite_2d.modulate = Color(0, 0, 0, 0.75)
	normal_light.energy = 0
	super._ready()
	

func start_active_pentagram_effects() -> void:
	pentagram_light_tween = create_tween().set_loops()
	pentagram_rotate_tween = create_tween().set_loops()
	pentagram_light_tween.tween_property(pentagram_light, "rotation", deg_to_rad(180), 2)
	pentagram_light_tween.tween_property(pentagram_light, "rotation", deg_to_rad(360), 2)
	pentagram_rotate_tween.tween_property(pentagram_light, "scale", Vector2(2.5, 2.5),1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	# 1.32 is the magic number
	pentagram_rotate_tween.tween_property(pentagram_light, "scale", Vector2(1.32, 1.32),1.32).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)


func stop_active_pentagram_effects() -> void:
	# You probably need to tween things to zero first!!
	pentagram_light_tween.kill()
	pentagram_rotate_tween.kill()

func start_spawner() -> void:
	await start_spawner_effect()
	super.start_spawner()

func all_elements_destroyed() -> void:
	await end_spawner_effect()
	all_spawned_enemies_killed.emit()
	queue_free()

func connect_signals(element: Node2D) -> void:
	if element is EnemyClass:
		element.enemy_died.connect(func(): spawned_enemies_killed +=1)
	super.connect_signals(element)


func start_spawner_effect() -> void:
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(animated_sprite_2d, "modulate", Color(1,1,1,1), 0.75)
	tween.tween_property(normal_light, "energy", 0.8, 0.5)
	await tween.finished
	start_active_pentagram_effects()
	animated_sprite_2d.play("flicker")
	return


func spawn_element() -> Node2D:
	await spawn_entity_effect()
	return super.spawn_element()

func spawn_entity_effect() -> void:
	var light_flash_tween: Tween = create_tween()
	light_flash_tween.tween_property(normal_light, "energy", 9, 0.25)
	light_flash_tween.tween_property(normal_light, "energy", 0.8, 0.15)
	await light_flash_tween.finished

func end_spawner_effect() -> void:
	stop_active_pentagram_effects()
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(animated_sprite_2d, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_property(normal_light, "energy", 0, 0.2)
	await tween.finished
