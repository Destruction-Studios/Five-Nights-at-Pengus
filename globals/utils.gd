extends Node

func get_all_in_dir(path: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(path)
	if dir == null:
		return result
	
	dir.list_dir_begin()
	var dirName := dir.get_next()
	while dirName != "":
		if dirName.ends_with(".wav") or dirName.ends_with(".ogg") or dirName.ends_with(".mp3"):
			result.append(path + "/" + dirName)
		dirName = dir.get_next()
	dir.list_dir_end()
	
	return result

func load_all(all: Array[String]) -> Array[Resource]:
	var result: Array[Resource] = []
	for item in all:
		result.append(load(item))
	
	return result
