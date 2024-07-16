extends WindowDialog

var edit = false
var action = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generate_content(dic:Dictionary):
	if dic.has("Name"):
		$Panel/ScrollContainer/VBoxContainer/Title.text = dic.Name
		action[dic.jsonName] = null
	if dic.has("Desc"):
		$Panel/ScrollContainer/VBoxContainer/Desc.text = dic.Desc
	if dic.has("Params"):
		create_params(dic.Params)


func create_params(input):
	for i in input:
		var hb = HBoxContainer.new()
		var label = Label.new()
		label.rect_min_size.x = 160
		hb.add_child(label)
		var value = null
		
		if input.Params == "Bool":
			value = false
			action[action.keys()[0]] = value
			var cb = CheckBox.new()
			
			cb.connect("pressed",self,"change_param",[])
			
			

func _on_ActionEdit_popup_hide():
	if edit == false:
		get_parent().get_node("ActionDialog").popup_centered()
		




func change_param(name,newValue):
	pass


func _on_Cancel_pressed():
	self.hide()
