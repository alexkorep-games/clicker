extends Control

export var commodity_name := ""
export var commodity_id := ""
var amount := 0.0

func _ready():
	add_to_group("Commodity")
	get_node("%NameLabel").text = commodity_name

func save(json_obj):
	if not "commodity" in json_obj:
		json_obj["commodity"] = {}
	json_obj["commodity"][commodity_id] = {
		"amount": amount
	}

func load(json_obj):
	if not "commodity" in json_obj:
		return
	if not commodity_id in json_obj["commodity"]:
		return
	var commodity = json_obj["commodity"][commodity_id]
	amount = commodity["amount"]

func reset():
	amount = 0.0
	
func _process(delta):
	get_node("%QtyLabel").text = str(amount)
