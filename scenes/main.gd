extends Control

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_NewGameButton_pressed():
	for node in get_tree().get_nodes_in_group("Commodity"):
		node.reset()
	for node in get_tree().get_nodes_in_group("Factory"):
		node.reset()
	
