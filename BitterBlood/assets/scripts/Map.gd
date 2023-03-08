extends TextureRect

export(int) var scrollSpeed = 500
export(Color) var roomColour


var xdir
var ydir

var cellSize = 40
var pad = 1
var roomCoords
var roomSize

#Array references
var rmc
var rms

func _ready():
	
	#Define default roomCoords
	roomCoords = Vector2(cellSize, cellSize)
	roomSize = Vector2(cellSize, cellSize)
	
	#Add to map and persistent group
	add_to_group("Persistent")
	add_to_group("Globals")

func _process(delta):
	
	if is_visible():
		#Move Map
		xdir = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		ydir = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		
		rect_position.x -= xdir * scrollSpeed * delta
		rect_position.y -= ydir * scrollSpeed * delta

func _input(event):
	
	if event.is_action_pressed("mapToggle"):
		set_visible(bool(abs(int(is_visible())-1)))
		
		if (is_visible()):
			get_tree().paused = true
		else:
			get_tree().paused = false
		
		#Reset Scroll Position
		rect_position = Vector2.ZERO

func _draw():
	
	#Draw Everything Grayed out, assuming rmc is equal to anything
	if rmc:
		for i in rmc.size():
			draw_rect(Rect2(Vector2(rmc[i].x+pad, rmc[i].y+pad), rms[i]),Color.black,true)
			draw_rect(Rect2(Vector2(rmc[i].x+pad, rmc[i].y+pad), rms[i]),roomColour,false,2.0)
	
	
	#Draw the current room in white
	var ii = rmc.find(roomCoords)
	if ii != -1:
		draw_rect(Rect2(Vector2(rmc[ii].x+pad, rmc[ii].y+pad), rms[ii]), Color.white,false,2.0)

func loadData():
	
	#Get current room coordinates
	roomCoords *= owner.state.sceneIndex[owner.name]["roomCoords"]
	roomSize *= owner.state.sceneIndex[owner.name]["roomSize"]

	#Reference the coordinate and size arrays
	rmc = owner.state.sceneIndex.Map["roomCoords"]
	rms = owner.state.sceneIndex.Map["roomSize"]
	
	#Search Coordinates Array for matching coordinates, append if we cannot find them
	if rmc.find(roomCoords) == -1:
		rmc.append(roomCoords)
		rms.append(roomSize)
	
	#Update the map display
	update()
