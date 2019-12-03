TitleState = {}
TitleState.__index = TitleState


function TitleState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(TitleState, BaseState) -- inheritance: arg a inherits arg b
	
	return table.deepcopy(o)
end

function TitleState:enter(params)
	self.submenu = Submenu:init({
		
		x = winWidth * 0.25,
		y = winHeight * 0.75,
		width = winWidth * 0.5,
		font = "AvenirLight32",
		align = "center",
		
		selectedOption = params.selectedOption or 1,
		
		options = {
			{"Play", 
			function() 
				gSounds["start"]:stop()
				gSounds["start"]:play()
				gStateMachine:change("menu")
			end},
			{"Credits", 
			function() 
				--gSounds["start"]:stop()
				--gSounds["start"]:play()
				gStateMachine:change("credits")
			end},
			{"Quit", function() love.event.quit(0) end}
		}
	})
	
	if params.submenuActive then
		self.submenu:activate()
	end
end

function TitleState:update(dt)
	if self.submenu.active then
		self:updateSubmenu(dt)
	else
		self:updateNormal(dt)
	end
end

function TitleState:updateNormal(dt)
	if love.keyboard.wasInput("topArrow") or 
	love.keyboard.wasInput("bottomArrow") then
		gSounds["start"]:stop()
		gSounds["start"]:play()
		self.submenu:activate()
	end
	--[[
	if love.keyboard.wasInput("topArrow2") or
	love.keyboard.wasInput("bottomArrow2") then
		gAudioPlayer:takeDamage()
	end
	]]
end

function TitleState:updateSubmenu(dt)
	if love.keyboard.wasInput("up") then
		self.submenu:up()
	elseif love.keyboard.wasInput("down") then
		self.submenu:down()
	end
	
	if love.keyboard.wasInput("topArrow") then
		gSounds["back"]:stop()
		gSounds["back"]:play()
		self.submenu:deactivate()
	elseif love.keyboard.wasInput("bottomArrow") then
		self.submenu:select()
	end
end

function TitleState:render()
	love.graphics.setColor(gCurrentPalette.menuText)
	love.graphics.draw(gOctaveLogo, winWidth/2 - gOctaveLogo:getWidth()/8, winHeight*0.15, 0, 0.25)
	--love.graphics.printf("Octave", gFonts["AvenirLight64"], 0, love.graphics.getHeight()*0.25, love.graphics.getWidth(), "center")
	if self.submenu.active then
		self:renderSubmenu(dt)
	else
		self:renderNormal(dt)
	end
end

function TitleState:renderNormal() 
	love.graphics.printf("Press any button", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")

end

function TitleState:renderSubmenu()
	self.submenu:render()
end
