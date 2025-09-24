class_name StringUtils

static func string_to_int_array(src:String, delimiter:String = ":") -> Array[int]:
	var ret:Array[int] = []
	var arr = src.split(delimiter)
	for s:String in arr:
		if s.length() > 0:
			ret.push_back(s.to_int())
	return ret
	
static func string_to_float_array(src:String, delimiter:String = ":") -> Array[float]:
	var ret:Array[float] = []
	var arr = src.split(delimiter)
	for s:String in arr:
		if s.length() > 0:
			ret.push_back(s.to_float())
	return ret
	
