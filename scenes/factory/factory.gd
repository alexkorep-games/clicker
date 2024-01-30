extends FactoryControl

export var factory_name := "Factory name"
export var factory_id := "factory_id"

export var automatic := false

# Map with the commodity id as key and the amount of the commodity as value.
export var generated_commodities := {}

# The multiplier of commodities that are generated, per level
export var generated_commodity_multiplier := 1

# Map with the commodity id as key and the amount of the commodity as value.
export var consumed_commodities := {}

# The multiplier of commodities that are consumed, per level
export var consumed_commodity_multiplier := 1

# The amount of commodities that are need to upgrade from 0 to 1st level
export var upgrade_cost := {}

# The multiplier of the amount of commodities that are need to upgrade to the next level
export var upgrade_multiplier := 1.5

# Current level
var _level := 1

var _last_generate_time := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Factory")
	get_node("%NameLabel").text = name

func _find_commodity(commodity_id) -> Node:
	var commodities := get_tree().get_nodes_in_group("Commodity")
	for commodity in commodities:
		if commodity.commodity_id == commodity_id:
			return commodity
	return null

func can_upgrade():
	var multiplier := pow(upgrade_multiplier, _level + 1)
	for commodity_id in upgrade_cost:
		var commodity := _find_commodity(commodity_id)
		if commodity.amount < upgrade_cost[commodity_id] * multiplier:
			return false
	return true

func upgrade():
	if not can_upgrade():
		return
	var multiplier := pow(upgrade_multiplier, _level + 1)
	_level += 1
	for commodity_id in upgrade_cost:
		var commodity := _find_commodity(commodity_id)
		commodity.amount -= upgrade_cost[commodity_id] * multiplier

func can_generate():
	var multiplier := pow(consumed_commodity_multiplier, _level)
	for commodity_id in consumed_commodities:
		var commodity := _find_commodity(commodity_id)
		if commodity.amount < consumed_commodities[commodity_id] * multiplier:
			return false
	return true

func generate():
	if not can_generate():
		return

	var consule_multiplier := pow(consumed_commodity_multiplier, _level)
	for commodity_id in consumed_commodities:
		var commodity := _find_commodity(commodity_id)
		commodity.amount -= consumed_commodities[commodity_id] * consule_multiplier

	var generate_multiplier := pow(generated_commodity_multiplier, _level)
	for commodity_id in generated_commodities:
		var commodity := _find_commodity(commodity_id)
		commodity.amount += generated_commodities[commodity_id]*generate_multiplier

func _process(_delta):
	update_ui()
	if not automatic:
		return
	var time = OS.get_ticks_msec()
	if time - _last_generate_time > 1000:
		_last_generate_time = time
		generate()


func save(json_obj):
	if not "factory" in json_obj:
		json_obj["factory"] = {}
	json_obj["factory"][factory_id] = {
		"level": _level
	}

func load(json_obj):
	if not "factory" in json_obj:
		return
	if not factory_id in json_obj["factory"]:
		return
	var factory = json_obj["factory"][factory_id]
	_level = factory["level"]

func reset():
	_level = 1
	_last_generate_time = 0

func update_ui():
	get_node("%LevelLabel").text = str(_level)
	get_node("%UpgradeButton").disabled = not can_upgrade()
	get_node("%GenerateButton").visible = not automatic

func _on_UpgradeButton_pressed():
	upgrade()
	
func _on_GenerateButton_pressed():
	generate()
