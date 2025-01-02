class_name SpellStackWord extends Label

var word: String:
	set(string):
		word = string
		text = string
		pivot_offset = Vector2(size.x/2, size.y/2)
var position_in_stack: int # does it make sense to have this here or should the parent be in control of that?

@export var HIGHLIGHT_COLOR: Color
var tween: Tween 

func _ready() -> void:
	tween = create_tween().set_loops()
	# TODO - you could update these tweens to use set_speed_scale to compensate for the slow mo effect!!
	#tween.set_speed_scale()
	if SpellSelector:
		modulate = SpellSelector.equipped_spell_resource.primary_color
		tween.tween_property(self, "modulate", SpellSelector.equipped_spell_resource.secondary_color, 0.25)
		tween.tween_property(self, "modulate", SpellSelector.equipped_spell_resource.primary_color, 0.25)
	else:
		tween.tween_property(self, "modulate", HIGHLIGHT_COLOR, 0.5)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	appear_effects() # TODO - you could change this to do the effect every time it becomes visible?
	Events.player_entered_casting_state.connect(appear_effects)
	Events.player_exited_casting_state.connect(disappear_effects)

func _process(delta: float) -> void:
	# Keep pivot offset within the center
	pivot_offset = Vector2(size.x/2, size.y/2)
	pass

func appear_effects() -> void:
	scale.y = 0
	var tween_scale: Tween = create_tween()
	tween_scale.tween_property(self, "scale", Vector2(scale.x, 1), 0.33*Engine.time_scale).set_ease(Tween.EASE_OUT)

func disappear_effects() -> void:
	scale.y = 1
	var tween_scale: Tween = create_tween()
	tween_scale.tween_property(self, "scale", Vector2(scale.x, 0), 0.2*Engine.time_scale).set_ease(Tween.EASE_OUT)
