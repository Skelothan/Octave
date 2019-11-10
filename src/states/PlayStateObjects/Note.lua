Note = {}
Note.__index = Note

function Note:init(params, playState)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.isDestroyed = false
	self.isHit = false
	
	-- Corresponds to pad angle. Integer.
	self.pad = params.pad or 1

	-- When drawn, centered on radius.
	-- Exact size will be determined by screen size.
	self.x = params.x
	self.y = params.y

	self.radius = params.radius
	
	self.directionChanged = false
	
	-- The lane the note travels on. Integer from 1-24.
	self.lane = params.lane or 2
	
	-- The angle of the lane the note travels on relative to the pad.
	-- Integer from 1-3.
	-- 1 = counterclockwise, 2 = normal, 3 = clockwise
	self.laneAngle = math.oimod(self.lane, 3)
	
	--[[ 
	self.noteAngle:
	The absolute angle of the lane travels on. Integer from 1-8.
	Set in setSpeeds().
	]]
		
	self.speed = params.speed
	self:setSpeeds()
	
	-- 1: bottom, 2: top, 3: both
	self.noteType = params.noteType or 1
	
	self.outlineColor = params.outlineColor or {0, 0, 0, 1}
	if noteType == 1 then
		self.noteColor = gCurrentPalette.noteColorBottom
	elseif noteType == 2 then
		self.noteColor = gCurrentPalette.noteColorTop
	else 
		self.noteColor = gCurrentPalette.noteColorBoth
	end
	
	self.score = params.score or 10000
	
	--self.timeAlive = 0
		
	return table.deepcopy(o)
end

function Note:setSpeeds()
	self.noteAngle = math.oimod((self.pad + (self.laneAngle - 2)), 8)
	local theta = math.pi / 4 * self.noteAngle
	
	self.dx = -self.speed * math.cos(theta)
	self.dy = -self.speed * math.sin(theta)
end

function Note:update(dt)
	--self.timeAlive = self.timeAlive + dt
	if not self.isHit then
		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt
	else
		self.destroyTimer = math.max(self.destroyTimer - dt, 0)
		if self.destroyTimer == 0 then
			self.isDestroyed = true
		else
			self.outlineColor[4] = self.outlineColor[4] - dt * 6
			self.noteColor[4] = self.noteColor[4] - dt * 6
		end
	end
end

function Note:onHit()
	self.isHit = true -- triggers destroying animation, stops movement, will be destroyed when isDestroyed is true
	self.destroyTimer = 3/60
end

function Note:changeDirection()
	--print(self.timeAlive)
	self.laneAngle = 2
	self:setSpeeds()
	self.directionChanged = true
	
	--gSounds["noteHit"]:stop()
	--gSounds["noteHit"]:play()
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