extends WindowDialog

var edit = false
var action = ""
var updatedAction = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generate_content(dic:Dictionary):
	for i in $Panel/ScrollContainer/VBoxContainer.get_children():
		if !i.name in ["Title","Desc","Break"]:
			i.queue_free()
	parse_json_data(dic, $Panel/ScrollContainer/VBoxContainer)


func parse_json_data(data, parentNode):
	if data.has("Name"):
		$Panel/ScrollContainer/VBoxContainer/Title.text = data.Name
	
	if data.has("Desc"):
		$Panel/ScrollContainer/VBoxContainer/Desc.text = data.Desc
	
	
	var param_list = data["Params"]
	action = data["jsonName"]
	for param in param_list:
		var hb = HBoxContainer.new()
		var lab = Label.new()
		lab.rect_min_size.x = 160
		hb.add_child(lab)
		var node
		if param["Params"] == "Bool":
			node = CheckBox.new()
			lab.text = param["Name"]
			node.connect("toggled", self, "_on_checkbox_toggled", [param["jsonName"]])
		elif param["Params"] == "Int":
			node = LineEdit.new()
			lab.text = param["Name"]
			node.connect("text_changed", self, "_on_textedit_changed", [param["jsonName"]])
		elif param["Params"] == "String":
			node = LineEdit.new()
			lab.text = param["Name"]
			node.connect("text_changed", self, "_on_textedit_changed", [param["jsonName"]])
		elif param["Params"] == "Array":
			node = VBoxContainer.new()
			var label = Label.new()
			label.text = param["Name"]
			node.add_child(label)
			parse_json_data({"Params": param["items"]}, node)
		elif param["Params"] == "Dictionary":
			node = VBoxContainer.new()
			var label = Label.new()
			label.text = param["Name"]
			node.add_child(label)
			parse_json_data({"Params": param["items"]}, node)
		if node:
			lab.text = lab.text + " - "
			lab.align = lab.ALIGN_RIGHT
			hb.add_child(node)
			parentNode.add_child(hb)
			node.show()
			

func _on_ActionEdit_popup_hide():
	if edit == false:
		get_parent().get_node("ActionDialog").popup_centered()
		


func _on_checkbox_toggled(button_pressed, jsonName):
	updatedAction[jsonName] = button_pressed
	print("Updated JSON data: ", updatedAction)
	


func _on_textedit_changed(newText, jsonName):
	updatedAction[jsonName] = newText
	print("Updated JSON data: ", updatedAction)



func create_action_json():
	
	var tempo = {}
	var refAction = {}
	
	for i in get_parent().get_node("ActionDialog").actionsList[get_parent().get_node("ActionDialog").tabName]:
		if i.jsonName == action:
			refAction = i
			break
	
	if refAction["Params"].size() <= 1:
		tempo[action] = updatedAction[""] 
	else:
		tempo[action] = updatedAction
	return tempo
	
func _on_Cancel_pressed():
	self.hide()


func _on_Ok_pressed():
	var final = create_action_json()
	print(final)
	get_parent().currentJson[get_parent().page][action] = final[action]
	get_parent().load_dialogue_page()
	edit = true
	self.hide()
