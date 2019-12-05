TextEffect = {}
TextEffect.__index = TextEffect

function TextEffect:init(params)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.width = winWidth
	self.x = params.x - self.width/2 or -10
	self.y = params.y or -10
	
	self.text = params.text or ""
	
	self.color = table.deepcopy(gCurrentPalette.menuText)
	self.isDestroyed = false
	
	return table.deepcopy(o)
end

function TextEffect:update(dt)
	self.color[4] = math.max(self.color[4] - 1.5 * dt, 0)
	self.y = self.y - winWidth * 1/32 * dt
	if self.color[4] == 0 then self.isDestroyed = true end
end

function TextEffect:render()
	love.graphics.setColor(self.color)
	love.graphics.printf(self.text, gFonts["AvenirMedium16"], self.x, self.y, self.width, "center")
end