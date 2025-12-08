extends Node

enum PENGU_POSITIONS {
	START = 1,
	SECOND = 2,
	RIGHT_HALLWAY = 3,
	HALLWAY_BEHIND = 4,
	ROOM_BEHIND = 5,
	
	WINDOW_RIGHT = 6,
	WINDOW_LEFT = 7,
	WINDOW_LEFT_LAY = 8,
	ROOM_TOP_LEFT = 9,
	
	DOOR = 10,
}

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
