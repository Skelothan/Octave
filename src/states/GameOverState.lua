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

	self.currChar = 65
	self.choosingName = true
	self.scoreName = ""
	self.maxLetters = 6
end

function GameOverState:update(dt)
	self.stopInputTimer = math.max(self.stopInputTimer - dt, 0)
	if self.choosingName and love.keyboard.wasInput("down") then
		self.currChar = self.currChar + 1
		if string.len(self.scoreName) == 0 and self.currChar == 58 then
			self.currChar = 65
		elseif string.len(self.scoreName) == 0 and self.currChar == 91 then
			self.currChar = 48
		elseif string.len(self.scoreName) ~= 0 and self.currChar == 58 then
			self.currChar = 97
		elseif string.len(self.scoreName) ~= 0 and self.currChar == 123 then
			self.currChar = 48
		end
	elseif self.choosingName and love.keyboard.wasInput("up") then
		self.currChar = self.currChar - 1
		if string.len(self.scoreName) == 0 and self.currChar == 64 then
			self.currChar = 57
		elseif string.len(self.scoreName) == 0 and self.currChar == 47 then
			self.currChar = 90
		elseif string.len(self.scoreName) ~= 0 and self.currChar == 96 then
			self.currChar = 57
		elseif string.len(self.scoreName) ~= 0 and self.currChar == 47 then
			self.currChar = 122
		end
	end
	if love.keyboard.wasInput("bottomArrow") and self.choosingName then
		self.scoreName = self.scoreName .. string.char(self.currChar)
		self.currChar = 97
		if string.len(self.scoreName) == self.maxLetters then
			self.choosingName = false
		end
	elseif self.stopInputTimer <= 0 and love.keyboard.wasInput("bottomArrow") and not self.choosingName then
		gAudioPlayer:changeAudio(love.audio.newSource("sfx/Welcome_to_Octave.wav", "stream"))
		gAudioPlayer:setLooping(true)
		gAudioPlayer:playAudio()
		gStateMachine:change("menu", {})
	end

end

function GameOverState:render()
	love.graphics.setColor(gCurrentPalette.menuText)
	
	if self.isWon then
		love.graphics.printf("You Win!", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center")
	else
		love.graphics.printf("Game Over", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center")
	end

	love.graphics.printf("Enter your name: ", gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 - 50, love.graphics.getWidth(), "center")
	
	love.graphics.rectangle(
		"line",
		love.graphics.getWidth()/2 - love.graphics.getWidth() / 12,
		love.graphics.getHeight() / 2, 
		love.graphics.getWidth() / 6,
		50
	)

	if(self.choosingName) then
		love.graphics.printf(self.scoreName .. string.char(self.currChar), 
			gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
	else
		love.graphics.printf(self.scoreName, gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
	end

	love.graphics.printf("Your Score: " .. comma_value(self.score), 
		gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + love.graphics.getHeight() / 12, love.graphics.getWidth(), "center")

	if self.stopInputTimer <= 0.5 then
		if self.fadeTextColor[4] ~= 1 then
			self.fadeTextColor = 1 - 2 * self.stopInputTimer
		end
		if self.choosingName then
			love.graphics.printf("Press [down triangle] to select", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
		else
			love.graphics.printf("Press [down triangle] to return", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
		end
	end
end