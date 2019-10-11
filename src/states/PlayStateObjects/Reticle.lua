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
	self.outlineColor = params.outlineColor or {0, 0, 0, 1}
	self.padColor = params.padColor or {0, 127/255, 1, 1}
	
	return table.deepcopy(o)
end

function Pad:update(dt)
	-- decrement active timer, deactivate once over
	self.activeTimer = math.max(self.activeTimer - dt, 0)
	if self.activeTimer == 0 then
		self.active = false
	end
end

function Pad:onPress()
	self.active = true
	-- Current window is two frames. Should playtest if this is too big/small.
	self.activeTimer = 2/60
end

function Pad:render()
	-- Draw outline
	love.graphics.setColor(self.outlineColor)
	local outlineRadius = self.radius * 1.2
	love.graphics.circle("fill", self.x, self.y, outlineRadius)
	-- Draw pad
	love.graphics.setColor(self.padColor)
	love.graphics.circle("fill", self.x, self.y, self.radius)
	-- Reset draw color
	love.graphics.resetColor()
end