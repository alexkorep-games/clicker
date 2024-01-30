extends Factory

func _ready():
	get_node("%NameLabel").text = name

func _process(_delta):
	update_ui()

func update_ui():
	get_node("%LevelLabel").text = str(_level)
	get_node("%UpgradeButton").disabled = not can_upgrade()
	get_node("%GenerateButton").visible = not automatic

func _on_UpgradeButton_pressed():
	upgrade()
	
func _on_GenerateButton_pressed():
	generate()
