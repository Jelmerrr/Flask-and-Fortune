extends Node

const MINUTESINDAY = 1440
const MINNUTESINHOUR= 60

var time: float = 0.0 #measured in minutes
var precentOfDayPassed: float

var dayDurationInMinutes: float = 15 #This controls the time it takes for 1 ingame day

var dayDurationInDelta: float
var inGameMinuteInDelta: float
var timeScaleMultiplier: float #Used for lighting cycle functions

var dayCounter: float
var percentOfDayPassed: float

func _ready() -> void:
	#1 delta = 1 second
	#1 minute = 60 delta
	#2pi = 1 day = 1440 minutes = 86400 delta
	dayDurationInDelta = dayDurationInMinutes * 60
	timeScaleMultiplier = PI / (0.5 * dayDurationInDelta)
	inGameMinuteInDelta = dayDurationInDelta / MINUTESINDAY

func _physics_process(delta: float) -> void:
	#1 delta = 1 second
	time += delta * timeScaleMultiplier
	var dayRef = dayCounter
	dayCounter = (time / timeScaleMultiplier) / dayDurationInDelta
	percentOfDayPassed = dayCounter - floor(dayCounter)
	if ceilf(dayRef) != ceilf(dayCounter):
		GlobalSignalBus.newDay.emit()
