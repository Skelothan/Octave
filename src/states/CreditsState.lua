CreditsState = {}
CreditsState.__index = CreditsState

function CreditsState:init(params)
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	setmetatable(CreditsState, BaseState)
	return table.deepcopy(o)
end

function CreditsState:enter(params)
end

function CreditsState:update(dt)
	if love.keyboard.wasInput("topArrow") or 
	love.keyboard.wasInput("bottomArrow") then
		gStateMachine:change("title", {selectedOption = 2, submenuActive = true})
	end
end

function CreditsState:render()
	love.graphics.setColor(gCurrentPalette.menuText)
	--love.graphics.printf("Octave", gFonts["AvenirLight64"], 0, love.graphics.getHeight()*0.10, love.graphics.getWidth(), "center")
	drawLogo(winWidth/2, winHeight*0.05)
	love.graphics.printf("v 1.0.0", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.25, love.graphics.getWidth(), "center")
	
	love.graphics.printf("Team Lead", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.35, love.graphics.getWidth(), "center")
	love.graphics.printf("Jonathan Fischer", gFonts["AvenirLight24"], 0, love.graphics.getHeight()*0.40, love.graphics.getWidth(), "center")
	
	names = {"Will Ozeas", "Julia Shuieh", "Christoph Gaffud", "Aidan Peck", "Sanjay Salem", "Darien Weems", "Harine Choi"}
	
	local height = gFonts["AvenirLight24"]:getHeight()
	
	for i=1,#names do
	love.graphics.printf(names[i], gFonts["AvenirLight24"], 0, love.graphics.getHeight()*0.45+i*1.1*height, love.graphics.getWidth(), "center")
	end
end