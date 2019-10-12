PlayState = {}
PlayState.__index = PlayState

function PlayState:newPad(pX, pY, pRadius, pNum)
	color = self.palette.pad1
	if pNum % 2 == 1 then
		color = self.palette.pad2
	end
	table.insert(self.pads, Pad:init({
		x = pX, 
		y = pY, 
		radius = pRadius,
		padColor = color
		})
	)
	local lane11 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = (pNum+1)%8,
		laneColor = self.palette.laneColor
	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = (pNum+2)%8,
		laneColor = self.palette.laneColor
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = (pNum+3)%8,
		laneColor = self.palette.laneColor
	})
	table.insert(self.lanes, lane13)
end

function PlayState:makePads()
	local centerRadius = math.min(love.graphics.getHeight(), love.graphics.getWidth())/8
	local pRadius = 20

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
end

function PlayState:enter(params)
	self.palette = params.palette or gPalette["standard"]

	self.healthBar = HealthBar:init({healthColor = self.palette.healthColor})
	self:makePads()
end

function PlayState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayState, BaseState) -- inheritance: arg a inherits arg b
	
	self.pads = {}
	self.lanes = {}
	self.healthBar = {}
	self.notes = {}
	
	return table.deepcopy(o)
end

function PlayState:update(dt) 
	for k, pad in pairs(self.pads) do
		pad.selected = false
	end
	print(love.keyboard.isDown("s"))
	if love.keyboard.isHeld("down") and love.keyboard.isHeld("left") then 
		
		self.pads[2].selected = true
	elseif love.keyboard.isHeld("up") and love.keyboard.isHeld("left") then 
		self.pads[4].selected = true
	elseif love.keyboard.isHeld("up") and love.keyboard.isHeld("right") then 
		self.pads[6].selected = true
	elseif love.keyboard.isHeld("down") and love.keyboard.isHeld("right") then 
		self.pads[8].selected = true
	elseif love.keyboard.isHeld("down") then
		self.pads[1].selected = true
	elseif love.keyboard.isHeld("left") then
		self.pads[3].selected = true
	elseif love.keyboard.isHeld("up") then
		self.pads[5].selected = true
	elseif love.keyboard.isHeld("right") then
		self.pads[7].selected = true
	end
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