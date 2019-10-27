Pad = {}
Pad.__index = Pad

function Pad:init(params)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.active = false
	self.activeTimer = 0
	
	-- When drawn, centered on radius.
	-- Exact size will be determined by screen size.
	self.index = params.index
	self.x = params.x
	self.y = params.y
	self.radius = params.radius
	self.selected = false
	
	-- Numerically indexed tables
	self.selectedColor = params.selectedColor or {1, 1, 1, 1}
	self.outlineColor = params.outlineColor or {0, 0, 0, 1}
	self.padColor = params.padColor or {0, 127/255, 1, 1}

	self.activeColor = params.activeColor or {1, 1, 1, 1}
	self.activeOpacity = 0;

	self.particleSystem = nil;
	
	return table.deepcopy(o)
end

function Pad:setParticleSystem(pSystem)
	self.particleSystem = pSystem
	self.setPosition(self.x, self.y)
	pSystem:setDirection(-(math.pi/4 + self.index * math.pi/4))
	pSystem:setSpread(2)
end

function Pad:update(dt)

	-- decrement active timer, deactivate once over
	self.activeTimer = math.max(self.activeTimer - dt, 0)
	if self.activeTimer == 0 then
		self.active = false
	end
	self.particleSystem:update(dt)
end

function Pad:onPress(input)
	self.active = true
	self.activeOpacity = 1
	-- Current window is two frames. Should playtest if this is too big/small.
	self.activeTimer = 2/60

	self:emitPerfect()
end

function Pad:render()
	-- Draw outline
	local outlineRadius = 0
	if self.selected then
		love.graphics.setColor(self.selectedColor)
		outlineRadius = self.radius * 1.25
	else
		love.graphics.setColor(self.outlineColor)
		outlineRadius = self.radius * 1.2
	end
	
	love.graphics.circle("fill", self.x, self.y, outlineRadius, 40)
	-- Draw pad
	
	love.graphics.setColor(self.padColor)
	love.graphics.circle("fill", self.x, self.y, self.radius, 40)

	if self.active == false then 
		self.activeOpacity = math.max(0, self.activeOpacity - (.05*self.activeOpacity - .001))
	end
	love.graphics.setColor(self.activeColor[1], self.activeColor[2], self.activeColor[3], self.activeOpacity)
	love.graphics.circle("fill", self.x, self.y, self.radius, 40)

	love.graphics.draw(self.particleSystem)
	-- Reset draw color
	love.graphics.resetColor()
end

function Pad:emitPerfect()
	self.particleSystem:setParticleLifetime(gParticle["perfect"].lifeMin, gParticle["perfect"].lifeMax)
	self.particleSystem:setSpeed(gParticle["perfect"].speed)
	self.particleSystem:setRotation(gParticle["perfect"].rotateMin, gParticle["perfect"].rotateMax)
	self.particleSystem:setSpin(gParticle["perfect"].spinMin, gParticle["perfect"].spinMax)
	self.particleSystem:setEmissionRate(gParicle["perfect"].rate)
	self.particleSystem:emit(50)
	love.graphics.draw(self.particleSystem)
end