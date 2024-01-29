extends Control


onready var logic = $Logic

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("%ScoreLabel").text = str(int(logic.score))
	get_node("%ScorePerClickLabel").text = str(logic.score_per_click) + " (Level " + str(logic.click_upgrade_level) + ")"
	get_node("%AutoClickRateLabel").text = str(logic.auto_click_rate) + " (Level " + str(logic.auto_click_upgrade_level) + ")"
	
	get_node("%ScorePerClickUpgradeButton").text = "Upgrade for " + str(logic.click_upgrade_cost)
	get_node("%ScorePerClickUpgradeButton").disabled = not logic.can_upgrade_click()
	get_node("%AutoClickUpgradeButton").text = "Upgrade for " + str(logic.auto_click_upgrade_cost)
	get_node("%AutoClickUpgradeButton").disabled = not logic.can_upgrade_auto_click()
	

func _on_Button_pressed():
	logic.click()


func _on_ScorePerClickUpgradeButton_pressed():
	logic.upgrade_click()


func _on_AutoClickUpgradeButton_pressed():
	logic.add_auto_click()


func _on_NewGameButton_pressed():
	logic.new_game()
