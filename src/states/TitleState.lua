TitleState = {}
TitleState.__index = TitleState


function TitleState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(TitleState, BaseState) -- inheritance: arg a inherits arg b
	return table.deepcopy(o)
end

function TitleState:enter(params)
end

function TitleState:update(dt)
	if love.keyboard.wasInput("topArrow") or 
	love.keyboard.wasInput("bottomArrow") then
		gSounds["start"]:stop()
		gSounds["start"]:play()
		gStateMachine:change("menu")
	end
	--[[
	if love.keyboard.wasInput("topArrow2") or
	love.keyboard.wasInput("bottomArrow2") then
		gAudioPlayer:takeDamage()
	end
	]]
	gAudioPlayer:update(dt)
end

function TitleState:render() 
	love.graphics.setColor(gCurrentPalette.menuText)
	love.graphics.printf("Octave", gFonts["AvenirLight64"], 0, love.graphics.getHeight()*0.25, love.graphics.getWidth(), "center")
	love.graphics.printf("Press [down triangle]", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
	love.graphics.resetColor()
end