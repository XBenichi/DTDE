extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func generate_actions(json:Dictionary):
	for i in $TabContainer.get_children():
		i.queue_free()
	
	for i in json.size():
		var tabNode = Tabs.new()
		tabNode.name = json.keys()[i]
		var gridNode = GridContainer.new()
		gridNode.columns = 2
		var grid = gridNode
		var scrollContain = ScrollContainer.new()
		scrollContain.rect_size.x = 686
		scrollContain.rect_size.y = 222
		var realScroll = scrollContain
		
		
		for j in json[tabNode.name]:
			var buttsNode = Button.new()
			buttsNode.text = j.Name
			buttsNode.name = j.Name
			buttsNode.rect_min_size.x = 340
			buttsNode.rect_min_size.y = 30
			var realButts = buttsNode
			realButts.connect("pressed", self, "_on_button_pressed", [realButts])

			grid.add_child(realButts)
		
		realScroll.add_child(grid)
		tabNode.add_child(realScroll)
		
		$TabContainer.add_child(tabNode)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_cancel_pressed():
	self.hide()


func _on_ActionDialog_about_to_show():
	generate_actions(get_parent().get_json_file("res://Actions.json"))


func _on_button_pressed(button):
	print(button.text)
	get_parent().get_node("ActionEdit").edit = false
	get_parent().get_node("ActionEdit").popup_centered()
	self.hide()
