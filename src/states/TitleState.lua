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
	print("Hello World!")
end

function TitleState:render() 
	love.graphics.setFont(gFonts["AvenirLight32"])
	love.graphics.printf("Hello World", 0, 0, 10000000, "left")
end