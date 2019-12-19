PlayDemoState = {}
PlayDemoState.__index = PlayDemoState

function PlayDemoState:newPad(pX, pY, pRadius, pNum)
	color = gCurrentPalette.pad1
	laneColor = gCurrentPalette.laneColor
	if pNum % 2 == 1 then
		color = gCurrentPalette.pad2
		laneColor = gCurrentPalette.laneColor2
	end
	table.insert(self.pads, Pad:init({
		x = pX, 
		y = pY, 
		radius = pRadius,
		padColor = color,
		index = pNum
		})
	)
	local lane11 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum), 8),
		laneColor = laneColor
	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+1), 8),
		laneColor = laneColor
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+2), 8),
		laneColor = laneColor
	})
	table.insert(self.lanes, lane13)
end

function PlayDemoState:makePads()
	-- TODO: scale this to screen size
	local pRadius = 20
	--Add pads:

	--bottom right
	self:newPad(love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2), pRadius, 8)

	--bottom 
	self:newPad(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + centerRadius, pRadius, 1)
	
	--bottom left
	self:newPad(love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2), pRadius, 2)
	
	--left
	self:newPad(love.graphics.getWidth()/2 - centerRadius, 
		love.graphics.getHeight()/2, pRadius, 3)
	
	--top left
	self:newPad(love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2), pRadius, 4)
	
	--top
	self:newPad(love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2- centerRadius, pRadius, 5)
	
	--top right
	self:newPad(love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2), pRadius, 6)
	
	--right
	self:newPad(love.graphics.getWidth()/2 + centerRadius, 
		love.graphics.getHeight()/2, pRadius, 7)
end

function PlayDemoState:enter(params)
	self.pads = {}
	self.lanes = {}
	self.healthBar = HealthBar:init({healthColor = gCurrentPalette.healthColor})
	self.notes = {}
	
	self:makePads()
	
	for i=1,3 do
		self.notes[i] = Note:init({
			x = winWidth * 3/4,
			y = self.lanes[math.oimod(19 + 2 * i, 24)].padY,
			radius = 20,
			pad = 1,
			lane = 1,
			speed = 0,
			noteType = math.oimod(i+1,3),
			score = 1000
		})
	end
	
	self.pads[8].selected = true
end

function PlayDemoState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayDemoState, BaseState) -- inheritance: arg a inherits arg b
	
	return table.deepcopy(o)
end

function PlayDemoState:update(dt)
	if love.keyboard.wasInput("topArrow") then
		gStateMachine:change("menu", {})
	end
end

function PlayDemoState:render() 
	for k, lane in pairs(self.lanes) do
		lane:render()
	end
	for k, pad in pairs(self.pads) do
		pad:render()
	end
	for k, note in pairs(self.notes) do
		note:render()
	end
	self.healthBar:render(self.practice)
	
	-- Debug:
	--love.graphics.printf("Time: " .. self.timer, 0, 0, winWidth, "left")
	--love.graphics.printf("AudioDoneTimer: " .. self.audioDoneTimer, 0, 0, winWidth, "left")
	--love.graphics.printf("Note Type: " .. self.pads[2].noteTypePressed, 0, 0, winWidth, "left")
end
