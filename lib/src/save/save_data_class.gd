class_name SaveDataClass

const SAVE_DATA_PATH="res://save/data/"
static var s_class_map = {}

static func getClass(file):
	if !s_class_map.has(file):
		s_class_map[file] = load(SAVE_DATA_PATH + file)
	return s_class_map[file]
