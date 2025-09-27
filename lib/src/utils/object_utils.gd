class_name ObjectUtils

static var s_class_map:Dictionary = {}
static var s_file_map:Dictionary = {}

## 同ディレクトリ同名のシーンのパスを返す.
static func get_scene_name_by_script(cls:Script) -> String:
	return cls.resource_path.substr(0, cls.resource_path.length() - 3) + ".tscn"

## 同ディレクトリ同名のシーンがある場合生成する
static func create_scene_by_script(cls:Script):
	# xxx.gd -> xxx.tscnに変換
	var scene_path := get_scene_name_by_script(cls)
	var package = ResourceLoader.load(scene_path)
	if package is PackedScene:
		return package.instantiate()
	return null

## ファイル名からクラスを生成する.
## 同じファイル名のクラスがある場合正常に動作しない場合がある.
static func create_instance_by_file_name(file_name:String):
	var cls = find_class(file_name)
	if cls:
		return cls.new()
	return null
	
## ファイル名からクラスを検索する
## 同じファイル名のクラスがある場合正常に動作しない場合がある.
static func find_class(file_name:String):
	if !s_class_map.has(file_name):
		_init_file_map()
		if s_file_map.has(file_name):
			var file = s_file_map[file_name]
			var cls = load(file)
			if cls:
				s_class_map[file_name] = cls
	if s_class_map.has(file_name):
		return s_class_map[file_name]
	return null
		
static func _init_file_map():
	if s_file_map.size() > 0:
		return
	var files = _get_files("res://")
	for file in files:
		if file.get_extension() == "gd":
			s_file_map[file.get_file()] = file
			print("[%s] = %s" % [file.get_file(), file])
	
static func _get_files(path:String) -> Array[String]:
	var files:Array[String] = []
	_get_files_imp(path, files, path.ends_with("res://"))
	return files
			
static func _get_files_imp(path:String, ref_files:Array[String], is_top:bool = false):
	if path.ends_with("/") and !is_top:
		path = path.substr(0, path.length()-1)
	var dir_or_file_list = ResourceLoader.list_directory(path)
	var add_slash = "/"
	if is_top:
		add_slash = ""
	for dir_or_file in dir_or_file_list:
		if dir_or_file.ends_with("/"):
			_get_files_imp(path + add_slash + dir_or_file, ref_files)
		else:
			ref_files.push_back(path + add_slash + dir_or_file)
