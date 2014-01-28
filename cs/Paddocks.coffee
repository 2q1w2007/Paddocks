# Paddocks(Game) logic in CoffeeScript.
# Complie into JavaScript and use it in every platform.
# Author - Xavier Yao

console.log 'Hello World!'
console.log 'A bite of CoffeeScript '

# Exported variables
	#Paddocks
Paddocks = {}
(exports ? this).Paddocks = Paddocks

# Classes
	# Assuming that the grid is like this(take a 3pts*3pts grid as eg.):
	#	1--2--3
	#	|  |  |
	#	4--5--6
	#	|  |  |
	#	7--8--9
class Line
	# *SIGNIFICANT* no checking process
	constructor: (from,to) ->
		dot = eval 'side'
		# Make sure from < to
		if from > to
			@from = to
			@to = from
		else
			@from = from
			@to = to
		# Create projection
		if @from < dot and @to == @from + 1 # 1-2,2-3
			@projection =
				[
					from : @from
					to   : @to
				]
		else if @from > dot * (dot - 1) # 7-8,8-9
			@projection = 
				[
					from : @from - dot
					to   : @to - dot
				]
		else if @from % dot == 0 # 3-6,6-9
			@projection = 
				[
					from : @from - 1
					to   : @to - dot
				]
		else if @from % dot == 1 and @to == @from + dot # 1-4,4-7
			@projection = 
				[
					from : @from
					to   : @from + 1
				]
		else if @to == @from + 3 # 2-5,5-8
			@projection = 
				[
					{
						from : @from - 1
						to   : @from
					},
					{
						from : @from
						to   : @from + 1
					}
				]
		else # 4-5,5-6
			@projection = 
				[
					{
						from : @from
						to   : @to
					},
					{
						from : @from - dot
						to   : @to - dot
					}
				]
	toString: ()->
		"#{@from},#{@to}"

# Inner variales
	# ......

side = {}#- lines pre side
score = {}#- object. p1:int,p2:int (assert p1 goes first in every game.)
grid = {}#- K-V pairs, K - 'from,to', V - boolean, is drew 
currentPlayer = {}#- string.
maxScore = {} #- max score
allProjections = {}

# Inner functions
	# ......

	# On new line drew. Judge whether scored.
onNewLineDrew = (line) ->
	log 'd',"Line drew #{line}"
	scored = false
	for proj in line.projection
		do (proj) ->
			if (grid["#{proj.from},#{proj.from + side}"] and grid["#{proj.from + 1},#{proj.to + side}"] and grid["#{proj.from + side},#{proj.to + side}"]) and allProjections["#{proj.from},#{proj.to}"] isnt true 
				score["#{currentPlayer}"] = score["#{currentPlayer}"] + 1
				scored = true
	if !scored
		currentPlayer = if currentPlayer == 'p1' then 'p2' else 'p1'
	log 'i',"Scores: P1 #{score.p1}  P2 #{score.p2}"
	log 'i',"It's now #{currentPlayer}'s turn!"
	printGrid() 
# TEMP
getLine = (line) ->
	if grid[line.toString()]
		if line.to == line.from + 3
			'|'
		else
			'--'
	else if line.to == line.from + 3
			' '
		else
			'  '
# TEMP
printGrid = () ->
	console.log "1#{getLine new Line 1,2}2#{getLine new Line 2,3}3"
	console.log "#{getLine new Line 1,4 }  #{getLine new Line 2,5}  #{getLine new Line 3,6}"
	console.log "4#{getLine new Line 4,5}5#{getLine new Line 5,6}6"
	console.log "#{getLine new Line 4,7}  #{getLine new Line 5,8}  #{getLine new Line 6,9}"
	console.log "7#{getLine new Line 7,8}8#{getLine new Line 8,9}9"
# Exported functions
	# ......

	#Initialize function.
	# dot - dot per line in the grid (sidelength).
initialize = (dot) ->
	side = dot
	score = 
		p1 : 0
		p2 : 0
	grid = {}
	grid["#{whichLine},#{whichLine + 1}"]  = false  for whichLine in [1..(side*side - 1)]
	grid["#{whichLine},#{whichLine + side}"] = false for whichLine in [1 .. side*(side - 1)]
	allProjections = {}
	allProjections["#{whichLine},#{whichLine + 1}"] = false for whichLine in [1 .. side * (side - 1)] when whichLine % side isnt 0
	currentPlayer = 'p1'
	maxScore = Math.pow (side - 1),2

	# Link two points(draw a line)
drawLine = (from,to) ->
	line = new Line from,to
	grid[line.toString()] = true
	onNewLineDrew line

Paddocks.initialize = initialize
Paddocks.drawLine = drawLine

# Interfaces (Should be overritten in View-Controller-side)
	# ......
	# Judgement
judge = (whoScored,score) ->
	log 'i',"#{currentPlayer} scores!"
	# Game over
win = (winner) ->

	# Log
log = (lv,info) ->
	console.log("Log.#{lv}   #{info}")
	# Error
		# ......
# Tests
Paddocks.initialize 3
Paddocks.drawLine 4,5
Paddocks.drawLine 5,6
Paddocks.drawLine 7,8
Paddocks.drawLine 8,9
Paddocks.drawLine 4,7
Paddocks.drawLine 6,9
Paddocks.drawLine 5,8
