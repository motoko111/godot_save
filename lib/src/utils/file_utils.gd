class_name FileUtils

# res://配下はビルド後にアクセスできなくなる(Editorでしか使えない)
#static func getFiles(path):
#	var ret = []
#	var dir = DirAccess.open(path)
#	var files = dir.get_files()
#	for file in files:
#		print("get_file:" + str(file.get_file()) + " get_base_dir:" + str(file.get_base_dir()))
#		ret.append(file)
#	return ret
	
static func getFiles(path:String) -> Array[String]:
	var files:Array[String] = []
	_getFiles(path, files)
	if true:
		for file in files:
			# print("get_file:" + str(file.get_file()) + " get_base_dir:" + str(file.get_base_dir()))
			print("get_file:" + str(file))
	return files
			
static func _getFiles(path:String, ref_files:Array[String]):
	if path.ends_with("/"):
		path = path.substr(0, path.length()-1)
	var dir_or_file_list = ResourceLoader.list_directory(path)
	for dir_or_file in dir_or_file_list:
		if dir_or_file.ends_with("/"):
			_getFiles(path + "/" + dir_or_file, ref_files)
		else:
			ref_files.push_back(path + "/" + dir_or_file)
			
static func existsFile(path:String) -> bool:
	return ResourceLoader.exists(path)

static func write(path:String, data:String) -> bool:
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		DirAccess.make_dir_absolute(path.get_base_dir())
	var file:FileAccess = null
	file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		print("[FileUtils::write] open error : " + str(FileAccess.get_open_error()))
		return false
	file.store_string(data)
	file.close()
	print("[FileUtils::write] path:" + str(path) + " save" + " success.")
	return true

static func read(path:String) -> String:
	if !FileAccess.file_exists(path):
		print("[FileUtils::read] loadData failed... not found " + str(path))
		return ""
	var file:FileAccess = null
	file = FileAccess.open(path,FileAccess.READ)
	if !file:
		print("[FileUtils::read] open error : " + str(FileAccess.get_open_error()))
		return ""
	var data = file.get_as_text()
	print("[FileUtils::read] path:" + str(path) + " load" + " success.")
	return data

static func delete(path:String) -> bool:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("[FileUtils::delete] path:" + str(path) + " delete success.")
		return true
	return false
