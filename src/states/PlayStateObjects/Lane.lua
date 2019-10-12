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
		
	local height = math.min(love.graphics.getHeight() - self.padY, self.padY - 0)
	
	if 1 == self.angle or (7 == self.angle) then
		self.endpointX = self.padX + (height*1.5)
	elseif 3 == self.angle or self.angle == 5 then
		self.endpointX = self.padX - (height*1.5)
	elseif self.angle == 2 or self.angle == 6 then
		self.endpointX = self.padX
	elseif self.angle == 4 then
		self.endpointX = 0
	elseif self.angle == 8 then
		self.endpointX = love.graphics.getWidth()
	end
	
	if 1 <= self.angle and self.angle <= 3 then
		self.endpointY = self.padY + (height*1.5)
	elseif 5 <= self.angle and self.angle <= 7 then
		self.endpointY = self.padY - (height*1.5)
	else
		self.endpointY = self.padY
	end
	
	-- Numerically indexed table 
	self.laneColor = params.laneColor or {60/255, 127/255, 1, 120/255}
	-- Not currently used, will be used for fade if we get there
	self.alphaLimit = (params.laneColor and params.laneColor[4]) or 120/255
	
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