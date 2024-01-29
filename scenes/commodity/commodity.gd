extends Node2D


export var commodity_name := ""
export var commodity_id := ""
var amount := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save(json_obj):
	if not "commodity" in json_obj:
		json_obj["commodity"] = {}
	json_obj["commodity"][commodity_id] = amount

func load(json_obj):
	if "commodity" in json_obj:
		if commodity_id in json_obj["commodity"]:
			amount = json_obj["commodity"][commodity_id]
	
