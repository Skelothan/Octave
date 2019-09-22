require "src/dependencies"

function love.load()
	-- Set image scaling settings
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- Seed RNG, just in case we use it
	math.randomseed(os.time())
	
	-- Set window title
	love.window.setTitle("Octave")
	
	-- initialize state machine
	gStateMachine = StateMachine:init({
		["title"] = function() return TitleState:init() end,
		["menu"] = function() return MenuState:init() end
	})
	gStateMachine:change("title", {})
	
	-- initialize global assets
	loadFonts()
	gBackground = Background:init("oscCircle")
	
	love.keyboard.keysPressed = {}
	love.keyboard.bindings = {}
end


function love.update(dt)
	gBackground:update(dt)
	
	gStateMachine:update(dt)
	
	love.keyboard.keysPressed = {}
	--stores the actual inputs
	love.keyboard.input = {}
end

function love.resize(x, y)
	
end

--INPUT HANDLING BEGIN
function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
	local action = keys[key]
	love.keyboard.inputs[action] = true;
end

--[[ 
Last I was told, the default love.keypressed can only be accessed from main. 
Thus, this function lets us get key press callbacks from anywhere.
I was taught this on an earlier version of Love though, so I've no idea if this 
is still necessary. Might be worth testing.
]]


--stores the keys and what they are bound to
local keys = {
	escape = "togglePauseMenu",
	
	--player 1
	r = "upArrow",
	t = "upArrow",
	f = "downArrow",
	g = "downArrow",
	w = "up",
	a = "left",
	s = "down",
	d = "right",
	y = "togglePauseMenu",
	
	--player 2
	space = "upArrow2",
	z = "upArrow2",
	c = "downArrow2",
	v = "downArrow2",
	up = "up2",
	down = "down2",
	left = "left2",
	right = "right2",
	x = "togglePauseMenu"
	}


function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key] or false
end
	
--INPUT HANDLING END

function love.draw()
	gBackground:render()
	
	gStateMachine:render()
end

-- Sets draw color to white
function love.graphics.resetColor()
	love.graphics.setColor(1, 1, 1, 1)
end
