Submenu = {}
Submenu.__index = Submenu

function Submenu:init(params)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.active = false
	
	-- List of name/function pairs, numerically indexed
	-- {{"option", function()}, {"choice", function()} ... }
	self.options = params.options
	self.selectedOption = params.selectedOption or 1
	
	self.x = params.x or 0
	self.y = params.y or 0
	self.width = params.width or winWidth
	self.font = params.font or "AvenirLight16"
	self.align = params.align or "left"
	
	self.textColor = table.deepcopy(gCurrentPalette.menuText)
	
	return table.deepcopy(o)
end

function Submenu:activate()
	self.active = true
end

function Submenu:deactivate()
	self.active = false
end

function Submenu:updateColor()
	self.textColor = table.deepcopy(gCurrentPalette.menuText)
end

function Submenu:up()
	if self.selectedOption ~= 1 then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
	end
	self.selectedOption = math.max(1, self.selectedOption - 1)
end

function Submenu:down()
	if self.selectedOption ~= #self.options then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
	end
	self.selectedOption = math.min(#self.options, self.selectedOption + 1)
end

function Submenu:select()
	self.options[self.selectedOption][2]()
end

function Submenu:render()
	if self.active then
		local font = gFonts[self.font]
		local height = font:getHeight()
		for k, option in pairs(self.options) do
			if k == self.selectedOption then
				self.textColor[4] = 1
			else
				self.textColor[4] = 0.5
			end
			love.graphics.setColor(self.textColor)
			love.graphics.printf(option[1], font, self.x, self.y + (k - 1) * 1.1 * height, self.width, self.align)
		end
	end
end