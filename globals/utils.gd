extends Node

enum PENGU_POSITIONS {
	START = 1,
	CROSSROADS = 2,
	RIGHT_HALLWAY = 3,
	HALLWAY_BEHIND = 4,
	ROOM_BEHIND = 5,
	
	WINDOW_RIGHT = 6,
	WINDOW_LEFT = 7,
	WINDOW_LEFT_LAY = 8,
	ROOM_TOP_LEFT = 9,
	
	DOOR = 10,
}

#Returns PENGU_POSITION
func get_next_pengu_pos(current: PENGU_POSITIONS):
	var next = PENGU_POSITIONS.find_key(current + 1)
	return PENGU_POSITIONS.get(next)
