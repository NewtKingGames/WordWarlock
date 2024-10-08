extends Node

# Spells used for enemy shield bubbles
var enemy_spell_shield_words: Array[String] = ["Disarm", "Pierce", "Break", "Shatter", "Dismantle", "Destroy", "Demolish", "Relinquish"]

# TODO see if you can get enums to work or define the enum in the spell as well to avoid hard coded strings?
enum Spells {FIREBALL, ICE_SHIELD, HASTE}

var known_spells_classes: Dictionary = {
	"FIREBALL": Fireball,
 	"ICE SHIELD": IceShield,
	"THUNDERSTORM": Thunderstorm,
	"HASTE": Haste,
	"BOOMERANG": Boomerang
}

var fire_themed_words: Array[String] = ["BLAZE", "EMBER", "CHAR", "BURN", "FIERY", "HEAT", "FLAME", "SCORCH", "KINDLE", "SEAR", "FLASH", "LAVA", "FLARE", "GLINT", "SINGE", "ARDENT", "CINDER", "CHARCOAL", "TORCH", "FIREBALL", "OVERHEAT", "SEARING", "ENFLAME", "BURNISH", "RAGING"]
var ice_themed_words: Array[String] = ["ICE", "FROST", "CHILL", "SNOW", "COLD", "HAIL", "GLACIER", "CRYSTAL", "SLUSH", "RIME", "FROSTBITE", "SHIVER", "BLIZZARD", "FRIGID", "FREEZE", "HAILSTORM", "ICICLE", "FROSTY", "HOARFROST", "SHIVERING", "GLACIAL", "ICEBERG", "TUNDRA", "SNOWFLAKE", "FROSTING", "FROSTBITE", "SLEET", "RIMEFROST", "COLD SNAP", "SNOWSTORM", "BREEZE", "GLACIAL", "HAILSTONE", "FROSTFALL", "ICY", "WINTER", "SNOWDRIFT", "HARDEN", "FROSTWEAVE", "SHIVER", "ICEWALL", "FREEZE", "RIME"]
var electric_themed_words: Array[String] = ["ZAP", "SPARK", "JOLT", "SHOCK", "CHARGE", "FLASH", "CURRENT", "STING", "BLAST", "SURGE", "CRACKLE", "ELECTRO", "VOLTS", "ARC", "STATIC", "LIGHTNING", "ENERGY", "STATIC", "POWER", "FLASH", "BLITZ", "SURGE", "HIT", "TINGLE", "JITTER", "ELECTRIC", "SPARKLE", "CRACK", "JOLT", "TASER", "ELECTRIFY", "ELECTRONS", "FIZZ", "JOLT", "POWER", "SPARKY", "VOLTAGE", "FLARE", "STING", "LIGHTNING", "SHOCKWAVE", "FIZZLE", "BURST", "SHOCKWAVE", "TINGLE", "ENERGY"]
var throwing_themed_words: Array[String] = ["THROW", "HURL", "CAST", "TOSS", "FLING", "DART", "PITCH", "CHUCK", "LAUNCH", "FLARE", "SHOOT", "JAVELIN", "FLING", "TOSS", "CAST", "HURL", "PROJECT", "DISK", "MISSILE", "SLING", "JAB", "SPIN", "SHOOT", "DARTS", "CHUCK", "TOSSING", "FLINGING", "HURLED", "THROWN", "PITCH", "LOFT", "SPLASH", "JAB", "FLARE", "HURL", "SPIN", "TWIRL", "HEAVE", "CATAPULT", "PROJECTILE", "JAVELINS", "MISSILE", "FIRE"]
var known_spell_random_words: Dictionary = {
	"FIREBALL": fire_themed_words,
	"ICE SHIELD": ice_themed_words,
	"THUNDERSTORM": electric_themed_words,
	"BOOMERANG": throwing_themed_words
}

var known_spells_scenes: Dictionary = {
	"FIREBALL": load("res://Scenes/projectiles/fireball.tscn"),
 	"ICE SHIELD": load("res://Scenes/projectiles/ice_shield.tscn"),
 	"THUNDERSTORM": load("res://Scenes/projectiles/thunder_storm.tscn"),
	"HASTE": load("res://Scenes/projectiles/haste_spell.tscn"),
	"BOOMERANG": load("res://Scenes/projectiles/boomerang.tscn")
}

# Retruns a packed scene for a spell or null
func get_spell_scene_for_string(spell_string) -> Object:
	if known_spells_scenes.has(spell_string):
		return known_spells_scenes[spell_string]
	return null

func is_string_known_spell(input: String) -> bool:
	return known_spells_classes.has(input.to_upper())	

# Returns null if the spell is not known
func get_known_spell_for_string(input: String) -> Object:
	if is_string_known_spell(input.to_upper()):
		return known_spells_classes[input.to_upper()]
	return null
