GameOverState = {}
GameOverState.__index = GameOverState

function GameOverState:init(params)
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	setmetatable(GameOverState, BaseState)
	return table.deepcopy(o)
end

function GameOverState:enter(params)
	gAudioPlayer:stopAudio()
	self.score = params.score or 0;
	self.fadeTextColor = gCurrentPalette.menuText
	self.isWon = params.isWon or false
	self.stopInputTimer = 4
	self.file = params.file
end

function GameOverState:update(dt)
	self.stopInputTimer = math.max(self.stopInputTimer - dt, 0)
	if self.stopInputTimer <= 0 and love.keyboard.wasInput("bottomArrow") then
		gAudioPlayer:changeAudio(gMenuMusic)
		gAudioPlayer:setLooping(true)
		gAudioPlayer:playAudio()
		gStateMachine:change("menu", {})
	end
end

function GameOverState:render()
	love.graphics.setColor(gCurrentPalette.menuText)
	
	if self.isWon then
		love.graphics.printf("You Win!", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), "center")
	else
		love.graphics.printf("Game Over", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), "center")
	end
	
	love.graphics.printf("Your Score: " .. comma_value(self.score), gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")

	if self.stopInputTimer <= 0.5 then
		if self.fadeTextColor[4] ~= 1 then
			self.fadeTextColor = 1 - 2 * self.stopInputTimer
		end
		love.graphics.printf("Press [down triangle] to return", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
	end
end