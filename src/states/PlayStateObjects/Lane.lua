Lane = {}
Lane.__index = Lane

function Lane:init(params)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	-- This object only exists visually.
	--[[ 
	When drawn, takes the location of the pad and an angle and draws the lane
	from that. The pad's X and Y are set to its center, and the radius is the 
	radius of the inner colored circle, not the outline.
	]]
	self.padX = params.padX
	self.padY = params.padY
	self.padR = params.padR
	
	
	-- An integer from 1 to 8, where 8 is pointing right and 
	-- decreases going counterclockwise.
	self.angle = params.angle
	
	local theta = self.angle * math.pi / 4
	local perpen = theta + math.pi/2
	local perpen2 = theta - math.pi/2
	
	-- A table of vertices used to draw the lane.
	--[[
	local x1 = self.padR * math.cos(perpen) + self.padX
	local y1 = self.padR * math.sin(perpen) + self.padY
	local x2 = self.padR * math.cos(perpen2) + self.padX
	local y2 = self.padR * math.sin(perpen2) + self.padY
	
	
	local y3 = 
	local y4 = 
	
	local x3 = 
	
	local x4 = 
	]]
	 
	
	--self.vertices = {x1, y1, x2, y2,}
	
	if 1 == self.angle or (7 <= self.angle and self.angle <= 8) then
		self.endpointX = love.graphics.getWidth()
	elseif 3 <= self.angle and self.angle <= 5 then
		self.endpointX = 0
	elseif self.angle == 2 or self.angle == 6 then
		self.endpointX = self.padX
	end
	
	if 1 <= self.angle and self.angle <= 3 then
		self.endpointY = love.graphics.getHeight()
	elseif 5 <= self.angle and self.angle <= 7 then
		self.endpointY = 0
	else
		self.endpointY = self.padY
	end
	
	-- Numerically indexed table 
	self.laneColor = params.laneColor or {60/255, 127/255, 1, 120/255}
	-- Not currently used, will be used for fade if we get there
	self.alphaLimit = 120/255
	
	return table.deepcopy(o)
end

--todo: add an update function, tween appearance/disappearance via fade?

function Lane:render()
	love.graphics.setColor(self.laneColor)
	--love.graphics.polygon(fill, self.vertices)
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(self.padR * 2)
	love.graphics.line(self.padX, self.padY, self.endpointX, self.endpointY)
	
	love.graphics.resetColor()
end