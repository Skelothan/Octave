Note = {}
Note.__index = Note

function Note:init(params)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.isDestroyed = false
	
	-- When drawn, centered on radius.
	-- Exact size will be determined by screen size.
	self.x = params.x
	self.y = params.y
	self.radius = params.radius
	
	-- Corresponds to pad angle. 
	self.pad = params.pad or 1
	
	-- 1 = counterclockwise, 2 = normal, 3 = clockwise
	self.lane = params.lane or 2
	
	local speed = params.speed
	local angle = (self.pad + (self.lane - 2)) % 8
	
	local theta = math.pi / 4 * angle
	
	self.dx = speed * math.cos(theta)
	self.dy = speed * math.sin(theta)
	
	-- 1: bottom, 2: top, 3: both
	self.noteType = params.noteType or 1
	
	self.outlineColor = params.outlineColor or {0, 0, 0, 1}
	self.noteColor = params.noteColor or {0, 127/255, 1, 1}
	
	self.score = params.score or 2000
	
	return table.deepcopy(o)
end

function Note:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt	
end

function Note:onHit()
	self.isDestroyed = true
	
end

function Note:render()
	-- Draw outline
	love.graphics.setColor(self.outlineColor)
	love.graphics.circle("fill", self.x, self.y, self.radius)
	
	-- Draw triangles
	love.graphics.setColor(self.noteColor)
	local triangleRadius = self.radius * 0.9
	-- bottom triangle:
	if self.noteType % 2 == 1 then
		local triangleDownVertices = {
			self.x, 
			self.y + triangleRadius,
			self.x + triangleRadius * math.cos(math.pi/6),
			self.y - triangleRadius / 2,
			self.x - triangleRadius * math.cos(math.pi/6),
			self.y - triangleRadius / 2
		}
		love.graphics.polygon("fill", triangleDownVertices)
	end
	-- top triangle:
	if self.noteType >= 2 then
		local triangleUpVertices = {
			self.x, 
			self.y - triangleRadius,
			self.x + triangleRadius * math.cos(math.pi/6),
			self.y + triangleRadius / 2,
			self.x - triangleRadius * math.cos(math.pi/6),
			self.y + triangleRadius / 2
		}
		love.graphics.polygon("fill", triangleUpVertices)
	end
	-- Reset draw color
	love.graphics.resetColor()
end