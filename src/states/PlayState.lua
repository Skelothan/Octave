PlayState = {}
PlayState.__index = PlayState

function PlayState:newPad(pX, pY, pRadius, pNum)
	table.insert(self.pads, Pad:init({
		x = pX, 
		y = pY, 
		radius = pRadius
		})
	)
	local lane11 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = (pNum+1)%8

	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = (pNum+2)%8
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = (pNum+3)%8
	})
	table.insert(self.lanes, lane13)
end

function PlayState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayState, BaseState) -- inheritance: arg a inherits arg b
	
	self.pads = {}
	self.lanes = {}
	self.healthBar = HealthBar:init({}) -- todo: add palettes to everything
	self.notes = {}
	
	local centerRadius = math.min(love.graphics.getHeight(), love.graphics.getWidth())/8
	local pRadius = 20
	
	--Add pads:
	--bottom 
	self:newPad(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + centerRadius, pRadius, 0)
	
	--bottom left
	self:newPad(love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2), pRadius, 1)
	
	--left
	self:newPad(love.graphics.getWidth()/2 - centerRadius, 
		love.graphics.getHeight()/2, pRadius, 2)
	
	--top left
	self:newPad(love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2), pRadius, 3)
	
	--top
	self:newPad(love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2- centerRadius, pRadius, 4)
	
	--top right
	self:newPad(love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2), pRadius, 5)
	
	--right
	self:newPad(love.graphics.getWidth()/2 + centerRadius, 
		love.graphics.getHeight()/2, pRadius, 6)
	
	--bottom right
	self:newPad(love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2), pRadius, 7)
	
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
	self.healthBar:render()
	for k, note in pairs(self.notes) do
		note:render()
	end
end