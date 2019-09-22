TitleState = {}
TitleState.__index = TitleState


function TitleState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(TitleState, BaseState) -- inheritance: arg a inherits arg b
	return o
end

function TitleState:update(dt)
	if love.keyboard.wasInput("upArrow") or 
	love.keyboard.wasInput("downArrow") then
		gStateMachine:change("menu", {})
	end
end

function TitleState:render() 
	love.graphics.printf("Octave", gFonts["AvenirLight64"], 0, love.graphics.getHeight()*0.25, love.graphics.getWidth(), "center")
	love.graphics.printf("Press [down triangle]", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
end
