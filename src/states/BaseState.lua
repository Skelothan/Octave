BaseState = {}
BaseState.__index = BaseState

function BaseState:init()
	local o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function BaseState:enter(params) end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end