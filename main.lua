require "src/dependencies"

function love.load()
	-- Set image scaling settings
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- Fullscreen, retina display
	love.window.setMode(0, 0, {fullscreen = true, highdpi = true, msaa = 2})
	
	-- Contains constants
	require "src/constants"

	-- Seed RNG, just in caswe we use it
	math.randomseed(os.time())
	
	-- Set window title
	love.window.setTitle("Octave")
	
	-- initialize state machine
	gStateMachine = StateMachine:init({
		["title"] = function() return TitleState:init() end,
		["menu"] = function() return MenuState:init() end,
		["play"] = function() return PlayState:init() end, 
		["gameOver"] = function() return GameOverState:init() end
	})
	gStateMachine:change("title", {})

	
	-- initialize global assets
	loadFonts()
	loadSounds()
	gBackgroundImage = nil

	gCurrentPalette = gPalette["bluepink"]


	gBackground = Background:init("dualWaveRectangles")
	gCurrentSong = 1
	love.keyboard.keysPressed = {}
	love.keyboard.inputs = {}
	love.keyboard.keysDown = {}

	gAudioPlayer = AudioPlayer:init(love.audio.newSource("sfx/Welcome_to_Octave.wav", "stream"))
	gAudioPlayer:setLooping(true)
	gAudioPlayer:playAudio()
end


function love.update(dt)
	gBackground:update(dt)
	gAudioPlayer:update(dt)
	
	gStateMachine:update(dt)
	
	love.keyboard.keysPressed = {}
	--stores the actual inputs
	love.keyboard.inputs = {}	
end

function love.resize(x, y)
	winWidth = love.graphics.getWidth()
	winHeight = love.graphics.getHeight()
end

--INPUT HANDLING BEGIN
function love.keypressed(key)
	--love.keyboard.keysPressed[key] = true
	local action = gKeys[key] or "misc"
	love.keyboard.inputs[action] = true
	love.keyboard.keysDown[action] = true
end

function love.keyreleased(key)
	local action  = gKeys[key] or "misc"
	love.keyboard.keysDown[action] = false
end

--[[ 
Last I was told, the default love.keypressed can only be accessed from main. 
Thus, this function lets us get key press callbacks from anywhere.
I was taught this on an earlier version of Love though, so I've no idea if this 
is still necessary. Might be worth testing.
]]


--stores the keys and what they are bound to
gKeys = {
	escape = "togglePauseMenu",
	
	--player 1
	r = "topArrow",
	t = "topArrow",
	f = "bottomArrow",
	g = "bottomArrow",
	w = "up",
	a = "left",
	s = "down",
	d = "right",
	y = "togglePauseMenu",
	h = "unbound",
	
	--player 2
	space = "topArrow2",
	z = "topArrow2",
	c = "bottomArrow2",
	v = "bottomArrow2",
	up = "up2",
	down = "down2",
	left = "left2",
	right = "right2",
	x = "togglePauseMenu"
	
	}


function love.keyboard.wasInput(key)
	return love.keyboard.inputs[key] or false
end
	
function love.keyboard.isHeld(key)
	return love.keyboard.keysDown[key] or false
end
--INPUT HANDLING END

function love.draw()
	if false and gBackgroundImage then
		love.graphics.resetColor()
		love.graphics.draw(gBackgroundImage,0,0,0,love.graphics.getWidth()/1920, love.graphics.getHeight()/1080)
	end
	gBackground:render()
	
	gStateMachine:render()
end

-- Sets draw color to white
function love.graphics.resetColor()
	love.graphics.setColor(1, 1, 1, 1)
end
