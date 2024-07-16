extends Control

var currentJson = ""
var JsonPage = ""
var page = 0
var pageCount = 0
var token = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	currentJson = [{}]
	pageCount = currentJson.size()-1
	
	page = 0

func init_dialogue_page(path,dir=false): #run this everytime we create/load dialogue 
	if !dir:
		currentJson = get_json_file(path)
	else:
		currentJson = [{}]
	pageCount = currentJson.size()-1
	
	page = 0
	var pagevisual = (var2str(page+1) + "/" + var2str(pageCount+1))
	$Panel/Page/count.text = pagevisual 
	if currentJson is Array:
		if currentJson[0].has("DialogueToken"):
			token = currentJson[0]["DialogueToken"]
		load_dialogue_page()
	

func load_dialogue_page(): #run this everytime you change a page/add an action
	if currentJson is Array:
		JsonPage = currentJson[page]
		$Panel/ActionTree.update_tree(JsonPage)
		$Panel/Page/count.text = var2str(page+1) + "/" + var2str(pageCount+1)
	else:
		page = -1

func get_json_file(filepath: String):
	var file = File.new()
	print(filepath)
	if file.file_exists(filepath):
		file.open(filepath, File.READ)
		var text = file.get_as_text()
		var validation = validate_json(text)
		if validation == "": 
			return parse_json(text)
		else:
			push_warning("Json format had errors:\n" + validation)
			return {}
	else:
		push_warning("Was not able to find json at " + filepath)
		return {}


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_prev_pressed(): #prev page
	if page > 0:
		page = page - 1
		load_dialogue_page()


func _on_next_pressed(): #next page
	if page < pageCount:
		page = page + 1
		load_dialogue_page()


func _on_add_pressed(): #add page:
	if !currentJson is Array:
		currentJson = [{}]
		pageCount = currentJson.size()-1
		
		page = 0
	else:
		currentJson.insert(page+1,{})
		pageCount = currentJson.size()-1
		page = page + 1
	
	load_dialogue_page()


func _on_AddAction_pressed():
	$ActionDialog.popup_centered()
