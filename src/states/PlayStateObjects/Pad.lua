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
	self.activeOpacity = 0
	self.noteTypePressed = 0

	
	return table.deepcopy(o)
end

function Pad:update(dt)
	-- decrement active timer, deactivate once over
	self.activeTimer = math.max(self.activeTimer - dt, 0)
	if self.activeTimer == 0 then
		self.active = false
	end
	if not self.active then
		self.topArrowPressed = false
		self.bottomArrowPressed = false
		self.noteTypePressed = 0
	else
		if self.topArrowPressed and self.bottomArrowPressed then
			self.noteTypePressed = 3
		elseif self.topArrowPressed then
			self.noteTypePressed = 2
		elseif self.bottomArrowPressed then
			self.noteTypePressed = 1
		end
	end
	--print(self.active)
	--[[
	print("top " )
	print(self.topArrowPressed)
	print("bottom") 
	print(self.bottomArrowPressed)
	]]--
end

function Pad:onPress(input)
	self.active = true
	self.activeOpacity = 1
	-- Current window is two frames. Should playtest if this is too big/small.
	self.activeTimer = 10/60
	if(input == "topArrow") then

		self.topArrowPressed = true;
	elseif(input == "bottomArrow") then
		self.bottomArrowPressed = true
	end

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

