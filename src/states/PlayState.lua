PlayState = {}
PlayState.__index = PlayState

function PlayState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayState, BaseState) -- inheritance: arg a inherits arg b
	return o
end

function PlayState:update(dt) -- TODO: update this system to a prettier one

end

function PlayState:render() 
	
end