extends Node2D


var is_player_returning_from_level: bool = true

@onready var book_case_tile_slider_left: TileSlider = $BookCaseTileSliderLeft
@onready var book_case_tile_slider_right: TileSlider = $BookCaseTileSliderRight


var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	if is_player_returning_from_level:
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
