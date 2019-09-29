TitleState = {}
TitleState.__index = TitleState

function TitleState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(TitleState, BaseState) -- inheritance: arg a inherits arg b
	return o
end

function TitleState:update(dt) -- TODO: update this system to a prettier one
	if love.keyboard.wasPressed("j") or 
	love.keyboard.wasPressed("k") or 
	love.keyboard.wasPressed("l") then
		gStateMachine:change("menu", {})
	end
end

function TitleState:render() 
	love.graphics.printf("Octave", gFonts["AvenirLight64"], 0, love.graphics.getHeight()*0.25, love.graphics.getWidth(), "center")
	love.graphics.printf("Press [down triangle]", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
end

function TitleState:enter()
	createAudioPlayer = AudioPlayer:init(love.audio.newSource("sfx/Drop_In_Flip_Out.mp3", "stream"))
	createAudioPlayer:playAudio()
end