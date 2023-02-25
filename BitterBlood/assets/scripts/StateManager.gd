extends Node2D


export(Resource) var state

#Map Data
export(Vector2) var roomCoords
export(Vector2) var roomSize

var sceneName
#Here's the basic plan:

#Each scene has a node that stores data about the scene using Resources
#On runtime, the node will check to see if that Resource exists
#If it does, it will load the data from that Resource
#If it doesn't, it will create a new empty Resource
#Upon leaving the scene, the Resource will be updated and saved with all the necessary data
#Upon returning, that resource will be loaded and the data from it will be executed
#This should result in a persistent scene state without singletons

#NOTE: certain stats shouldn't be locked to one scene, like Health.

func _ready():
	
	#Get our subdictionary name
	sceneName = name
	
	#Access and create a subdictionary if we don't have one yet
	if !state.sceneIndex.has(sceneName):
		state.sceneIndex[sceneName] = {}
		
		#Create Map Array if one doesn't exist yet
		if !state.sceneIndex.has("Map"):
			state.sceneIndex["Map"] = {}
			state.sceneIndex.Map["roomCoords"] = []
			state.sceneIndex.Map["roomSize"] = []
			
		#Create Map Coords
		state.sceneIndex[sceneName]["roomCoords"] = roomCoords
		state.sceneIndex[sceneName]["roomSize"] = roomSize
		
		#Initiate Globals
		get_tree().call_group("Globals", "loadData")
		
		
	#If it does, just load the dang data
	else:
		print("Data Loaded")
		pushLoad()
	
#Run Update for every node that needs persistence
func pushUpdate():
	print("Update Called")
	get_tree().call_group("Persistent", "saveData")
	
func pushLoad():
	get_tree().call_group("Persistent", "loadData")
