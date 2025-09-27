class_name SaveDataManager

"""
# 使用例
# システムデータをロード
SaveDataManager.getInstance().getSystemDataAccess().loadCurrentData(0)
var system_data = SaveDataManager.getInstance().getSystemDataAccess().getCurrentData()
var index = system_data.last_save_index

# ユーザーデータをロードして現在ユーザーデータに設定
SaveDataManager.getInstance().getUserDataAccess().loadCurrentData(index)

# ユーザーデータを現在データに設定せずにロード
for i in range(0,10):
	var data = SaveDataManager.getInstance().getUserDataAccess().loadData(i,false)
	
# 現在ユーザーデータをデータ2に保存
SaveDataManager.getInstance().getUserDataAccess().saveCurrentData(2)
# システムデータを保存
SaveDataManager.getInstance().getSystemDataAccess().saveCurrentData(0)

# 省略
# システムデータをロード
SaveDataManager.getInstance().loadSystemData(0)
# ロードしたシステムデータを取得
var system_data = SaveDataManager.getInstance().getSystemData()
# システムデータを保存
SaveDataManager.getInstance().saveSystemData()

# ユーザーデータをロード
SaveDataManager.getInstance().loadUserData(0)
# ロードしたユーザーデータを取得
var system_data = SaveDataManager.getInstance().getUserData()
# ユーザーデータを保存
SaveDataManager.getInstance().saveUserData()

"""

static var s_instance = null;
static var SECURITY_KEY:String:
	set(v):
		ProjectSettings.set_setting("lib/save/security_key", v)
	get():
		return ProjectSettings.get_setting("lib/save/security_key", "012345ABCDE")
static var SAVE_DIR:String:
	set(v):
		ProjectSettings.set_setting("lib/save/save_data_path", v)
	get():
		return ProjectSettings.get_setting("lib/save/save_data_path", "user://save/")
static var USER_DATA_SCRIPT_PATH:String:
	set(v):
		ProjectSettings.set_setting("lib/save/user_data_script_path", v)
	get():
		return ProjectSettings.get_setting("lib/save/user_data_script_path", "res://lib/src/save/data/user_data.gd")
static var SYSTEM_DATA_SCRIPT_PATH:String:
	set(v):
		ProjectSettings.set_setting("lib/save/system_data_script_path", v)
	get():
		return ProjectSettings.get_setting("lib/save/system_data_script_path", "res://lib/src/save/data/system_data.gd")

const USER_DATA = "data_%d"
const SYSTEM_DATA = "system_%d"

var _user_data_access:SaveDataAccess = null
var _system_data_access:SaveDataAccess = null

# user:// の場所
# C:\Users\%use_name%\AppData\Roaming\Godot\app_userdata\%project_name%

static func getInstance() -> SaveDataManager:
	if s_instance == null:
		createInstance()
	return s_instance
	
static func createInstance():
	if s_instance == null:
		s_instance = SaveDataManager.new();
		s_instance.setup()
		
func setup():
	_user_data_access = SaveDataAccess.new(load(USER_DATA_SCRIPT_PATH), USER_DATA)
	_system_data_access = SaveDataAccess.new(load(SYSTEM_DATA_SCRIPT_PATH), SYSTEM_DATA)

func loadData(data_name, encrypt = true) -> String:
	var path = getSaveDataPath(data_name)
	if !FileAccess.file_exists(path):
		print("[SaveDataManager::loadData] loadData failed... not found " + str(path))
		return ""
	var file:FileAccess = null
	if encrypt:
		file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ,SECURITY_KEY)
	else:
		file = FileAccess.open(path,FileAccess.READ)
	if !file:
		print("[SaveDataManager::loadData] open error : " + str(FileAccess.get_open_error()))
		return ""
	var data = file.get_as_text()
	print("[SaveDataManager::loadData] path:" + str(path) + " save." + " data:" + str(data.length()))
	# print("[SaveDataManager::loadData] path:" + str(path) + " save." + " data:" + str(data))
	return data
	
func saveData(data_name, data:String, encrypt = true) -> bool:
	var path:String = getSaveDataPath(data_name)
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		DirAccess.make_dir_absolute(path.get_base_dir())
	var file:FileAccess = null
	if encrypt:
		file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE,SECURITY_KEY)
	else:
		file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		print("[SaveDataManager::saveData] open error : " + str(FileAccess.get_open_error()))
		return false
	file.store_string(data)
	file.close()
	print("[SaveDataManager::saveData] path:" + str(path) + " save." + " data:" + str(data.length()))
	# print("[SaveDataManager::saveData] path:" + str(path) + " save." + " data:" + str(data))
	return true
	
func deleteData(data_name) -> bool:
	var path = getSaveDataPath(data_name)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("[SaveDataManager::deleteData] path:" + str(path) + " delete.")
		return true
	return false

func getSaveDataPath(data_name) -> String:
	return SAVE_DIR + data_name + ".sav"
	
func getUserDataAccess() -> SaveDataAccess:
	return _user_data_access

func getSystemDataAccess() -> SaveDataAccess:
	return _system_data_access
	
func loadUserData(index:int):
	getUserDataAccess().loadCurrentData(index)
	
func saveUserData(index:int = -1):
	if index == -1:
		index = getUserDataAccess().getLastAccessIndex()
	getUserDataAccess().saveCurrentData(index)

func getUserData() -> UserData:
	return getUserDataAccess().getCurrentData()
	
func deleteUserData(index:int):
	getUserDataAccess().deleteData(index)
	
func loadSystemData(index:int):
	getSystemDataAccess().loadCurrentData(index)
	
func saveSystemData(index:int = -1):
	if index == -1:
		index = getSystemDataAccess().getLastAccessIndex()
	getSystemDataAccess().saveCurrentData(index)

func getSystemData() -> SystemData:
	return getSystemDataAccess().getCurrentData()

func deleteSystemData(index:int):
	getSystemDataAccess().deleteData(index)
