extends Tree

# Path from which to load the files and folders
var rootPath = "res://"

func _ready():

	update_file_tree(rootPath)

func update_file_tree(path):
	# Clear the existing tree
	clear()
	
	var root = create_item()
	
	_populate_tree(root, path, true)
	
	_collapse_all_items(root)

func _populate_tree(tree_item, path, is_root = false):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if fileName != "." and fileName != "..":
				var filePath = path.plus_file(fileName)
				if dir.current_is_dir():
					var folder_item = create_item(tree_item)
					folder_item.set_text(0, fileName)
					folder_item.set_icon(0, load("res://Assets/Icons/folder.png"))
					_populate_tree(folder_item, filePath)
				elif fileName.ends_with(".json"):
					if fileName != "Action.json":
						var file_item = create_item(tree_item)
						file_item.set_text(0, fileName)
						file_item.set_icon(0, load("res://Assets/Icons/page_white_text.png"))
			fileName = dir.get_next()
		dir.list_dir_end()

	# we dont wanna collapse the root now dont we?
	if not is_root:
		tree_item.set_collapsed(true)

func _collapse_all_items(tree_item):
	if not tree_item:
		return
	var child = tree_item.get_children()
	while child:
		child.set_collapsed(true)
		_collapse_all_items(child)
		child = child.get_next()



func get_folderPath(item: TreeItem) -> String:
	var pathParts = []
	while item != null:
		pathParts.append(item.get_text(0))  
		item = item.get_parent() 
	
	var reversedPath = []
	for i in range(pathParts.size()):
		reversedPath.append(pathParts[pathParts.size() - 1 - i])

	var filepath = rootPath + PoolStringArray(reversedPath).join("/")
	filepath = filepath.replace("res:///","res://")
	return filepath



func _on_FileTree_item_activated():
		var item = get_selected()  
		if item:
			var filename = item.get_text(0)
			if filename.ends_with(".json"):
				var folderPath = get_folderPath(item)
				var filePath = folderPath
				
			
				get_parent().get_parent().init_dialogue_page(filePath)

	
