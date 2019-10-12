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

	self.notes = {}
	
	return table.deepcopy(o)
end

function Pad:update(dt)
	--note collision
	if self.active or not self.active then
		for k, note in pairs(self.notes) do --notes is populated from within note.lua when spawned
			self.collides, self.dist = noteCollision(self, note)
			print(self.collides)
			if self.collides == true and note.isDestroyed == false then
				note:isHit()
				print("yeet")
			end
		end
	end

	-- decrement active timer, deactivate once over
	self.activeTimer = math.max(self.activeTimer - dt, 0)
	if self.activeTimer == 0 then
		self.active = false
	end

end

function Pad:onPress(input)
	self.active = true
	self.activeOpacity = 1
	-- Current window is two frames. Should playtest if this is too big/small.
	self.activeTimer = 2/60
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

	-- Reset draw color
	love.graphics.resetColor()
end

