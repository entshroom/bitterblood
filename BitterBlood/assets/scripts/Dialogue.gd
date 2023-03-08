extends Control

export var dialoguePath = ""
export(float) var textSpeed = 0.05

onready var timer = $Timer
onready var charName = $Name
onready var text = $Text
onready var portrait = $Portrait

var dialogue
var creator

var phraseNum = 0
var finished = false

func _ready():
	
	timer.wait_time = textSpeed
	dialogue = getDialogue()
	assert(dialogue, "Dialogue not found")
	nextPhrase()

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if finished:
			nextPhrase()
		else:
			text.visible_characters = len(text.text)

func getDialogue() -> Array:
	var f = File.new()
	assert(f.file_exists(dialoguePath), "File Path does not exist")
	
	f.open(dialoguePath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	

func nextPhrase() -> void:

	if phraseNum >= len(dialogue):
		creator.interactFunction(true)
		queue_free()
		return
	
	finished = false
	
	charName.bbcode_text = dialogue[phraseNum]["Name"]
	text.bbcode_text = dialogue[phraseNum]["Text"]
	
	text.visible_characters = 0
	
	var f = File.new()
	var img = dialogue[phraseNum]["Name"] + dialogue[phraseNum]["Emotion"] + ".png"
	if f.file_exists(img):
		portrait.texture = load(img)
	else: portrait.texture = null
	
	while text.visible_characters < len(text.text):
		text.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
	
	finished = true
	phraseNum += 1
	return
