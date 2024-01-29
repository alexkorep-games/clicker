extends Node

# Variables
var score: float = 0.0
var score_per_click: int = 1
var auto_click_rate: float = 0.0  # Automatic clicks per second

var click_upgrade_cost: int = 50  # Initial cost to upgrade click
var auto_click_upgrade_cost: int = 100  # Initial cost to upgrade auto click

var click_upgrade_level: int = 1  # Tracks the level of click upgrades
var auto_click_upgrade_level: int = 1  # Tracks the level of auto click upgrades

var COST_INCREMENT_RATE = 1.2
var AUTO_CLICK_INCREMENT_RATE = 0.5

var last_save_time = 0
var current_time = 0
var save_interval = 5  # Save every 5 seconds

# Called when the node enters the scene tree for the first time
func _ready():
	load_state()
	set_process(true)

func set_initial_state():
	score = 0.0
	score_per_click = 1
	auto_click_rate = 0.0
	click_upgrade_cost = 50
	auto_click_upgrade_cost = 100
	click_upgrade_level = 1
	auto_click_upgrade_level = 1

func new_game():
	set_initial_state()
	save_state()

# Process function to handle automatic clicks
func _process(delta):
	if auto_click_rate > 0:
		score += auto_click_rate * delta
		current_time += delta
		if abs(last_save_time - current_time) >= save_interval:
			save_state()
			last_save_time = current_time


# Function to handle a click
func click():
	score += score_per_click
	save_state()

# Function to check if click can be upgraded
func can_upgrade_click() -> bool:
	return score >= click_upgrade_cost

# Function to upgrade click value
func upgrade_click() -> bool:
	if can_upgrade_click():
		score -= click_upgrade_cost
		score_per_click += 1
		click_upgrade_level += 1
		click_upgrade_cost *= COST_INCREMENT_RATE  # Double the cost for the next upgrade
		save_state()
		return true
	return false

# Function to check if auto click can be upgraded
func can_upgrade_auto_click() -> bool:
	return score >= auto_click_upgrade_cost

# Function to add automatic clicking
func add_auto_click() -> bool:
	if can_upgrade_auto_click():
		score -= auto_click_upgrade_cost
		auto_click_rate += AUTO_CLICK_INCREMENT_RATE  # Increment by a fixed rate
		auto_click_upgrade_level += 1
		auto_click_upgrade_cost *= COST_INCREMENT_RATE
		save_state()
		return true
	return false

func save_state():
	var save_data = {
		"score": score,
		"score_per_click": score_per_click,
		"auto_click_rate": auto_click_rate,
		"click_upgrade_cost": click_upgrade_cost,
		"auto_click_upgrade_cost": auto_click_upgrade_cost,
		"click_upgrade_level": click_upgrade_level,
		"auto_click_upgrade_level": auto_click_upgrade_level
	}
	var save_file = File.new()
	save_file.open("user://save_game.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_state():
	var save_file = File.new()
	if save_file.file_exists("user://save_game.save"):
		save_file.open("user://save_game.save", File.READ)
		var save_data = parse_json(save_file.get_as_text())
		score = save_data["score"]
		score_per_click = save_data["score_per_click"]
		auto_click_rate = save_data["auto_click_rate"]
		click_upgrade_cost = save_data["click_upgrade_cost"]
		auto_click_upgrade_cost = save_data["auto_click_upgrade_cost"]
		click_upgrade_level = save_data["click_upgrade_level"]
		auto_click_upgrade_level = save_data["auto_click_upgrade_level"]
		save_file.close()
	else:
		set_initial_state()

