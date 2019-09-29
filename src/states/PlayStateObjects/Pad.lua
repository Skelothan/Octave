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
	self.x = params.x
	self.y = params.y
	self.radius = params.radius
	
	-- Numerically indexed tables
	self.outlineColor = params.outlineColor
	self.padColor = params.padColor
	
	return o
end

function Pad:update(dt)
	-- decrement active timer, deactivate once over
	self.activeTimer = math.max(self.activeTimer - dt, 0)
	if self.activeTimer = 0 then
		self.active = false
	end
end

function Pad:onPress()
	self.active = true
	-- Current window is two frames. Should playtest if this is too big/small.
	self.activeTimer = 2/60
end

function Pad:render()
	-- Draw pad
	love.graphics.setColor(self.padColor)
	love.graphics.circle(fill, self.x-self.radius, self.y-self.radius, self.radius)
	-- Draw outline
	love.graphics.setColor(self.outlineColor)
	local outlineRadius = self.radius * 1.2
	love.graphics.circle(fill, self.x-outlineRadius, self.y-outlineRadius, outlineRadius)
	-- Reset draw color
	love.graphics.resetColor()
end