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
		["menu"] = function() return MenuState:init() end,
		["play"] = function() return PlayState:init() end
	})
	gStateMachine:change("title", {})
	
	-- initialize global assets
	loadFonts()
	gBackground = Background:init("oscCircle")
	
	love.keyboard.keysPressed = {}
end


function love.update(dt)
	gBackground:update(dt)
	
	gStateMachine:update(dt)
	
	love.keyboard.keysPressed = {}
end

function love.resize(x, y)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

--[[ 
Last I was told, the default love.keypressed can only be accessed from main. 
Thus, this function lets us get key press callbacks from anywhere.
I was taught this on an earlier version of Love though, so I've no idea if this 
is still necessary. Might be worth testing.
]]
function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key] or false
end

function love.draw()
	gBackground:render()
	
	gStateMachine:render()
end

-- Sets draw color to white
function love.graphics.resetColor()
	love.graphics.setColor(1, 1, 1, 1)
end