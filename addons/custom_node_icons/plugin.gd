tool
extends EditorPlugin

var commodity_custom_icon: Texture
var factory_custom_icon: Texture

func _enter_tree():
	commodity_custom_icon = preload("res://addons/custom_node_icons/icons/commodity.png")
	add_custom_type("CommodityControl", 
		"Control", 
		preload("res://addons/custom_node_icons/commodity_control.gd"), 
		commodity_custom_icon)

	factory_custom_icon = preload("res://addons/custom_node_icons/icons/factory.png")
	add_custom_type("FactoryControl", 
		"Control", 
		preload("res://addons/custom_node_icons/factory_control.gd"), 
		factory_custom_icon)
	
func _exit_tree():
	remove_custom_type("CommodityControl")
	remove_custom_type("FactoryControl")
