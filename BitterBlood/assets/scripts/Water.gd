extends Node2D

export var k = 0.015; #Stiffness
export var d = 0.03; #Damping
export var spread = 0.0002; #Spread

export var springDistance = 32;
export var springNumber = 6;

export var depth = 60;
var targetHeight = position.y;
var bottom = targetHeight + depth;

onready var waterPolygon = $waterPolygon
onready var waterBorder = $waterBorder
#onready var entRect = $EntityCollider/Rect
#onready var entcol = $EntityCollider

export var borderThickness = 1.1;

#Spring Array
var springs = [];
var passes = 8;

var waterLength = springDistance*springNumber;

onready var waterSpring = preload("res://assets/prefabs/WaterSpring.tscn")

func _ready():
	
	bottom = targetHeight + depth
	
	waterLength = springDistance*springNumber;
	waterBorder.width = borderThickness;
	#entcol.position.x += (waterLength-springDistance) / 2;
	#entcol.position.y += depth/2+25
	#entRect.shape.set_extents(Vector2(waterLength/2,depth))
	for i in range(springNumber):
		var xPosition = springDistance * i;
		var w = waterSpring.instance();
		
		add_child(w);
		springs.append(w);
		w.initialize(xPosition, i);
		w.setCollisionWidth(springDistance);
		w.connect("splash",self,"splash");
		
func _physics_process(_delta):
	for i in springs:
		i.updateWater(k,d);
		
	#Store height difference between neighbours
	var left_deltas = [];
	var right_deltas = [];
	
	for _i in range(springs.size()):
		left_deltas.append(0);
		right_deltas.append(0);
		pass
		
	for _i in range(springs.size()):
		if (_i > 0):
			
			#Left Deltas
			left_deltas[_i] = spread * (springs[_i].height - springs[_i-1].height);
			springs[_i-1].velocity += left_deltas[_i];
		
		if (_i < springs.size()-1):
			
			#Right Deltas
			right_deltas[_i] = spread * (springs[_i].height - springs[_i+1].height);
			springs[_i+1].velocity += right_deltas[_i];

	newBorder();
	drawWater();
 
func splash(index, speed):
	if (index >= 0 && index < springs.size()):
		springs[index].velocity += speed;
	
func drawWater():

	var curve = waterBorder.curve;
	var points = Array(curve.get_baked_points());
	
	var waterPolygonPoints = points;
	
	var firstIndex = 0;
	var lastIndex = waterPolygonPoints.size()-1;
	
	waterPolygonPoints.append(Vector2(waterPolygonPoints[lastIndex].x, bottom));
	waterPolygonPoints.append(Vector2(waterPolygonPoints[firstIndex].x, bottom));
	
	waterPolygonPoints = PoolVector2Array(waterPolygonPoints);
	
	waterPolygon.set_polygon(waterPolygonPoints);

func newBorder():
	var curve = Curve2D.new().duplicate();
	
	var surfacePoints = []
	
	for i in range(springs.size()):
		surfacePoints.append(springs[i].position);
	
	for i in range(springs.size()):
		curve.add_point(surfacePoints[i]);
		
	waterBorder.curve = curve;
	waterBorder.smooth(true);
	waterBorder.update();



func _on_Timer_timeout():
		for n in range(springNumber):
			if randi() % 3 == 2:
				splash(n, randi() % 3)
