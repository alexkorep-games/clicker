extends Control

func _ready():
	load_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_NewGameButton_pressed():
	get_node("%ConfirmationDialog").show()
	
func new_game():
	for node in get_tree().get_nodes_in_group("Commodity"):
		node.reset()
	for node in get_tree().get_nodes_in_group("Factory"):
		node.reset()
	
func save_state():
	var save_data = {}
	for node in get_tree().get_nodes_in_group("Commodity"):
		node.save(save_data)
	for node in get_tree().get_nodes_in_group("Factory"):
		node.save(save_data)
	
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_state():
	var save_file = File.new()
	if save_file.file_exists("user://savegame.save"):
		save_file.open("user://savegame.save", File.READ)
		var save_data = parse_json(save_file.get_as_text())
		save_file.close()
		for node in get_tree().get_nodes_in_group("Commodity"):
			node.load(save_data)
		for node in get_tree().get_nodes_in_group("Factory"):
			node.load(save_data)

func _on_SaveTimer_timeout():
	save_state()

func _on_ConfirmationDialog_confirmed():
	new_game()
