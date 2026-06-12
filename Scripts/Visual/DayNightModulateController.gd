extends CanvasModulate

@export var gradient: GradientTexture1D

var time: float = 0.0

const MINPERDAY = 1440
const MINPERHOUR = 60
const INGAMEMINTODELTA = (2 * PI) / MINPERDAY

@export var dayDurationInSeconds: int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# ingamemintodelta = 1 min in game in delta = 0.0043
	#print(INGAMEMINTODELTA)
	
	# 1/60 second = 0.016 delta
	# 1 second = 1 delta
	#print(delta)
	
	# ingame min/delta = 3.8
	#print(delta / INGAMEMINTODELTA)
	
	# 1 day in game = 6.28 second irl
	# ratio = 1:6.28
	# 1 day in game = 376.99 delta
	#print(MINPERDAY / (delta / INGAMEMINTODELTA))
	# Above formula calculates 1 day length in delta
	#print(376.991118430775 / 60)
	
	# if 1 day = 60 seconds
	# 60 / 6.28 = time scale multiplier
	#print(60 / (MINPERDAY / (delta / INGAMEMINTODELTA)))
	
	# Time scale multipler = 9.54 for 1 min irl = 1 day in game
	# If we do the ratio calculator but with delta divided by time scale multiplier we get 60
	# Which means 1 day in game = 60 second irl
	#print(MINPERDAY / ((delta / 0.1591549430919) / INGAMEMINTODELTA))
	
	# 1 day in game in delta = MINPERDAY / (delta / INGAMEMINTODELTA)
	
	#Calculate multipler to achieve ratio of 1 day in game = selected length in seconds
	var dayDurationInDelta = dayDurationInSeconds / 60.0
	var timeScaleMultiplier = dayDurationInDelta / (MINPERDAY / (delta / INGAMEMINTODELTA))
	time += delta * timeScaleMultiplier
	var value = (sin(time - 0.5 * PI) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
