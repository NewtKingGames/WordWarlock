extends Node2D


# TODO - this should have an init function to allow for it to be passed in to constructor
var level_transition_context: LevelTransitionContext = LevelTransitionContext.new()

@onready var book_case_tile_slider_left: TileSlider = $BookCaseTileSliderLeft
@onready var book_case_tile_slider_right: TileSlider = $BookCaseTileSliderRight

@onready var intro_dialogue_player: DialoguePlayer = %IntroDialoguePlayer


# TODO - delete, used for testing the animation
var test_var: bool = false

var player: Player
@onready var player_spawn_return_from_level: Marker2D = %PlayerSpawn_ReturnFromLevel

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	if test_var or (level_transition_context and level_transition_context.transition_reason == LevelTransitionContext.TRANSITION_REASON.LEVEL_COMPLETED):
		# Disable the intro dialogue player
		intro_dialogue_player.queue_free()
		player.global_position = player_spawn_return_from_level.global_position
		# Lock player controls
		player.toggle_player_input(false)
		# TODO - put player in correct position - you should add a Marker2D
		# Hide player sprite
		player.visible = false
		# Let things sit for a blip
		await get_tree().create_timer(0.5).timeout
		# Open Doors
		book_case_tile_slider_left.slide_out()
		await book_case_tile_slider_right.slide_out()
		player.visible = true
		# Trigger player walk out and lock player control
		await player.move_player_in_direction_for_seconds(Vector2.DOWN, 1)
		# (wait?) close doors
		book_case_tile_slider_left.slide_back()
		await book_case_tile_slider_right.slide_back()
		# Release player control again
		player.toggle_player_input(true)
	elif level_transition_context.transition_reason == LevelTransitionContext.TRANSITION_REASON.INITIAL_GAME_LOAD:
		# Disable player control and play the fun animation
		player.toggle_player_input(false)
		player.character_animated_sprite.play("reanimate")
		await get_tree().create_timer(0.625).timeout
		player.toggle_player_input(true)
