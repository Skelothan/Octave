PlayState = {}
PlayState.__index = PlayState

function PlayState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayState, BaseState) -- inheritance: arg a inherits arg b
	
	self.pads = {}
	self.lanes = {}
	
	table.insert(self.pads, Pad:init({
		x = love.graphics.getWidth()/2, 
		y = love.graphics.getHeight()*3/4, 
		radius = 20
		})
	)
	local newLane = Lane:init({
		padX = love.graphics.getWidth()/2, 
		padY = love.graphics.getHeight()*3/4, 
		padR = 20,
		angle = 2
	})
	table.insert(self.lanes, newLane)
	local newLane2 = Lane:init({
		padX = love.graphics.getWidth()/2, 
		padY = love.graphics.getHeight()*3/4, 
		padR = 20,
		angle = 3
	})
	table.insert(self.lanes, newLane2)
	
	return table.deepcopy(o)
end

function PlayState:update(dt) 
	
end

function PlayState:render() 
	for k, lane in pairs(self.lanes) do
		lane:render()
	end
	for k, pad in pairs(self.pads) do
		pad:render()
	end
end