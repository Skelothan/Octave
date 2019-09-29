MenuState = {}
MenuState.__index = MenuState

function MenuState:init()
	local o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	setmetatable(MenuState, BaseState) -- inheritance: arg a inherits arg b
	return table.deepcopy(o)
end

function MenuState:update(dt)
	if love.keyboard.wasPressed("j") then
		gStateMachine:change("play", {})
	end
end

function MenuState:render()
end