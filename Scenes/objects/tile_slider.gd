class_name TileSlider
extends Node2D


@onready var tile_sprite: Sprite2D = $TileSprite
@export var sprite_texture: Texture = load("res://.godot/imported/bookshelf.png-0fb7e9b495e3ae8395052cbd1a95e146.ctex")
@export var slide_direction: Vector2 = Vector2.LEFT
@export var slide_magnitude: float = 50
@export var slide_out_time: float = 2.0
@export var slide_back_time: float = 2.0
@onready var slide_out_sound: AudioStreamPlayer2D = $SlideOutSound
@onready var slide_back_sound: AudioStreamPlayer2D = $SlideBackSound


# TODO - export the sound file?

var starting_global_position: Vector2

var slide_tween: Tween

var shake_offset: float = 0.0
func _ready() -> void:
	tile_sprite.texture = sprite_texture
	starting_global_position = global_position

func _process(delta: float) -> void:
	if shake_offset:
		# TODO - work on this visual effect more
		tile_sprite.offset = tile_sprite.offset + Vector2(randf_range(-shake_offset/4, shake_offset/4), 0)
	else:
		tile_sprite.offset = Vector2.ZERO

func slide_out() -> void:
	slide_out_sound.play()
	play_slide_effects()
	var destination_global_position: Vector2 = starting_global_position + (slide_direction*slide_magnitude)
	slide_tween = create_tween()
	slide_tween.tween_property(self, "global_position", destination_global_position, slide_out_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await slide_tween.finished
	stop_slide_effects()

func slide_back() -> void:
	slide_back_sound.play()
	play_slide_effects()
	slide_tween = create_tween()
	slide_tween.tween_property(self, "global_position", starting_global_position, slide_back_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await slide_tween.finished
	stop_slide_effects()

func play_slide_effects() -> void:
	shake_offset = 0.3

func stop_slide_effects() -> void:
	shake_offset = 0.0

# This can be deleted, borrowed code from the slay the spire tutorial
#func shake(thing: Node2D, strength: float, duration: float = 0.2) -> void:
	#print("shaking my tween")
	#if not thing:
		#return
	#var orig_pos := thing.position
	#var shake_count := 10
	#var tween := create_tween()
	#for i in shake_count:
		#var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		#var target := orig_pos + strength * shake_offset
		## Every other position, put it back at the original position
		#if i % 2 == 0:
			#target = orig_pos
		#tween.tween_property(thing, "position", target, duration/float(shake_count))
		## Get's weaker and weaker
		#strength *= 0.75
	#tween.finished.connect(func(): thing.position = orig_pos)
