HealthBar = {}
HealthBar.__index = HealthBar

function HealthBar:init(params)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.x = love.graphics.getWidth() / 2
	self.y = love.graphics.getHeight() / 2
	
	self.score = 0
	self.notesPerHP = 12
	self.health = 4 * self.notesPerHP
	self.maxHealth = 4 * self.notesPerHP
	
	self.radius = math.min(love.graphics.getHeight(), love.graphics.getWidth()) / 12
	
	-- Numerically indexed tables
	self.outlineColor = params.outlineColor or {0, 0, 0, 1}
	self.textColor = params.textColor or {1, 1, 1, 1}
	self.healthColor = params.healthColor or {0, 192/255, 0, 1}
	
	return table.deepcopy(o)
end

function HealthBar:update(dt)
	if love.keyboard.isDown("1") then
		self.health = 0
	end
	if self.health <= 0 then 
		gStateMachine:change("gameOver", {
			score = dScore, 
			isWon = false,
			backgroundColor = self.outlineColor,
			textColor = self.textColor
		})
	end
end

function HealthBar:takeDamage(dScore)
	--gAudioPlayer:takeDamage()
	self.health = math.max(self.health - self.notesPerHP, 0)
	self:incrementScore(-dScore)
	
end

function HealthBar:restoreHealth()
	self.health = math.min(self.health + 1, self.maxHealth)
end

function HealthBar:incrementScore(dScore)
	self.score = math.max(self.score + dScore, 0)
end

function HealthBar:render()
	-- Draw outline
	love.graphics.setColor(self.outlineColor)
	love.graphics.circle("fill", self.x, self.y, self.radius, 60)
	-- Draw health
	love.graphics.setColor(self.healthColor)
	love.graphics.arc("fill", self.x, self.y, self.radius * 0.9, math.pi * 3/2, math.pi * 3/2 - 2 * math.pi * (self.health/self.maxHealth), self.maxHealth * 4)
	-- Draw health segments and center
	love.graphics.setColor(self.outlineColor)
	love.graphics.circle("fill", self.x, self.y, self.radius * 0.8, 60)
	love.graphics.setLineWidth(self.radius * 0.1)
	local segmentRadius = self.radius * 0.95 
	love.graphics.line(self.x, self.y - segmentRadius, self.x, self.y + segmentRadius)
	love.graphics.line(self.x - segmentRadius, self.y, self.x + segmentRadius, self.y)
	-- Draw score text
	love.graphics.setColor(self.textColor)
	love.graphics.printf(self.score, gFonts["AvenirLight16"], self.x - self.radius, self.y - self.radius / 3, self.radius * 2, "center")
	-- Reset draw color
	love.graphics.resetColor()
end