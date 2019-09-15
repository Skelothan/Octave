require "src/dependencies"

function love.load()
	-- Set image scaling settings
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- Seed RNG, just in case we use it
	math.randomseed(os.time())
	
	-- Set window title
	love.window.setTitle("Octave")
	
	-- initialize global assets
	loadFonts()
	
	love.keyboard.keysPressed = {}
end



function love.update(dt)
	-- update everything currently in existence, pass in dt
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
	-- render everything currently in existence
end

