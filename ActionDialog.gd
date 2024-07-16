extends WindowDialog

var tabName = ""
var actionsList = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	actionsList = get_parent().get_json_file("res://Actions.json")

func generate_actions(json:Dictionary):
	actionsList = json
	for i in $TabContainer.get_children():
		i.queue_free()
	
	yield(get_tree().create_timer(0.01),"timeout")
	
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
			
			buttsNode.rect_min_size.x = 340
			buttsNode.rect_min_size.y = 30
			var realButts = buttsNode
			realButts.connect("pressed", self, "_on_button_pressed", [realButts])

			grid.add_child(realButts)
			buttsNode.text = j.Name
			buttsNode.name = j.Name
		
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
	var act = {}
	for i in actionsList[tabName]:
		if i.Name == button.name:
			act = i
			break
	
	get_parent().get_node("ActionEdit").generate_content(act)
	
	
	
	get_parent().get_node("ActionEdit").popup_centered()
	self.hide()


func _on_TabContainer_tab_changed(tab):
	tabName = get_node("TabContainer").get_child(tab).name
