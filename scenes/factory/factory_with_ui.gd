extends Factory

func _ready():
	get_node("%NameLabel").text = factory_name

func _process(_delta):
	update_ui()

func update_ui():
	get_node("%LevelLabel").text = "Level " + str(_level)
	get_node("%UpgradeButton").disabled = not can_upgrade()
	get_node("%GenerateButton").visible = not automatic
	get_node("%GenerateButton").disabled = _level <= 0

	# Upgrade
	var upgrade_price_label = get_node("%UpgradePriceLabel")
	var texts = []
	for commodity_id in upgrade_cost:
		var amount = get_current_upgrade_cost(commodity_id)
		var commodity = _find_commodity(commodity_id)
		var commodity_name = commodity.commodity_name
		texts.append(str(amount) + " " + commodity_name)
	upgrade_price_label.text = "\n".join(texts)

	# Consumes
	var consume_price_label = get_node("%ConsumeLabel")
	texts = []
	for commodity_id in consumed_commodities:
		var amount = get_current_consumed_amount(commodity_id)
		var commodity = _find_commodity(commodity_id)
		var commodity_name = commodity.commodity_name
		texts.append(str(amount) + " " + commodity_name + ("/sec" if automatic else ""))
	consume_price_label.text = "\n".join(texts)

	# Generates
	var generate_price_label = get_node("%GenerateLabel")
	texts = []
	for commodity_id in generated_commodities:
		var amount = get_current_generated_amount(commodity_id)
		var commodity = _find_commodity(commodity_id)
		var commodity_name = commodity.commodity_name
		texts.append(str(amount) + " " + commodity_name + ("/sec" if automatic else ""))
	generate_price_label.text = "\n".join(texts)

	

func _on_UpgradeButton_pressed():
	upgrade()
	
func _on_GenerateButton_pressed():
	generate()
