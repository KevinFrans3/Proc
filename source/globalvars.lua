grid = {}
collisionGrid = {}
cronjobs = {}
npc = {}

player = {
	x = 0,
	y = 0
}

winH = love.graphics.getHeight()
winW = love.graphics.getWidth()

camera = {
	x = 800,
	y = 800,
}

scale = 1
-- camerascale = 10

gridsize = 600

math.randomseed(os.time())
seed = math.random()
print(seed)