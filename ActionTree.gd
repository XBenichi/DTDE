extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_tree(data: Dictionary):
	clear()
	
	var rootItem = create_item() 
	rootItem.set_text(0, "Root")  
	
	for key in data.keys():
		if key != "DialogueToken":
			var keyNode = create_item()
			var displayName = key
			var actionsList = get_parent().get_parent().get_node("ActionDialog").actionsList
			for i in actionsList:
				for j in actionsList[i]:
					if j.has("jsonName"):
						if j.jsonName == key:
							displayName = j.Name
							break
				
			
			
			keyNode.set_text(0, displayName)  
			
			var value = str(data[key])
			keyNode.set_text(1, wrap_string_with_spaces(value,80))
	
	set_column_min_width(0, 100)  
	set_column_min_width(1, 200)  

func wrap_string_with_spaces(ogString: String, totalLength: int) -> String:
	var padLength = totalLength - 2  
	var spacesNeeded = padLength - ogString.length()
	
	if spacesNeeded < 0:
		ogString = ogString.substr(0, padLength)
		spacesNeeded = 0
	
	var paddedString = ogString + " ".repeat(spacesNeeded)
	return "(" + paddedString + ")"


func _on_ActionTree_item_activated():
	var item = get_selected()
	get_parent().get_parent().get_node("ActionEdit").popup_centered()
	get_parent().get_parent().get_node("ActionEdit").edit = true
