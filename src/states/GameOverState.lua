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

	love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
	self.score = params.score or 0;
	self.fadeTextColor = gCurrentPalette.menuText
	self.isWon = params.isWon or false
	self.stopInputTimer = 4
	self.song = params.song

	self.currChar = 65
	self.choosingName = self.isWon and not params.practice
	self.practice = params.practice
	self.scoreName = ""
	self.maxLetters = 6
	
	-- Play victory music if the game was won
	if self.isWon then
		gSounds["victory"]:stop()
		gSounds["victory"]:play()
	end
end

function sortScores(s1, s2)
	return s1.score > s2.score
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
	elseif self.choosingName and love.keyboard.wasInput("bottomArrow") then
		self.scoreName = self.scoreName .. string.char(self.currChar)
		self.currChar = 97
		if string.len(self.scoreName) == self.maxLetters then
			self.choosingName = false
		end
	elseif love.keyboard.wasInput("topArrow") then
		if string.len(self.scoreName) > 0 then
			self.choosingName = true
			self.scoreName = string.sub(self.scoreName, 1, string.len(self.scoreName)-1)
			if string.len(self.scoreName) == 0 then
				self.currChar = 65
			else
				self.currChar = 97
			end
		end
	end
	if self.stopInputTimer <= 0 and (love.keyboard.wasInput("togglePauseMenu") or 
		(not self.choosingName and love.keyboard.wasInput("bottomArrow"))) then
		if self.isWon and not self.practice then
			local highScore = {name = self.scoreName, score = self.score}
			table.insert(self.song.highScores, highScore)
			table.sort(self.song.highScores, sortScores)
			local jsonScores = json.encode( { highScores = self.song.highScores } )
			
			if love.filesystem.getInfo(self.song.saveFile) == nil then
				--love.filesystem.createDirectory("highScores/")
				love.filesystem.createDirectory(self.song.saveFile)
			end
			love.filesystem.write(self.song.saveFile .. "highScores.json", jsonScores, all)
		end
		gAudioPlayer:changeAudio(love.audio.newSource("sfx/Welcome_to_Octave.wav", "stream"))
		gAudioPlayer:setLooping(true)
		gAudioPlayer:playAudio()
		gSounds["victory"]:stop()
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

	if self.isWon and not self.practice then
		love.graphics.printf("Enter your name: ", gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 - 50, love.graphics.getWidth(), "center")
		love.graphics.rectangle(
			"line",
			love.graphics.getWidth()/2 - love.graphics.getWidth() / 12,
			love.graphics.getHeight() / 2, 
			love.graphics.getWidth() / 6,
			50
		)
	end

	if(self.choosingName) then
		love.graphics.printf(self.scoreName .. string.char(self.currChar), 
			gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
	elseif self.isWon and not self.practice then
		love.graphics.printf(self.scoreName, gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
	end

	if self.isWon then 
		love.graphics.printf("Your Score: " .. comma_value(self.score), 
			gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + love.graphics.getHeight() / 12, love.graphics.getWidth(), "center")
	else 
		love.graphics.printf("Your Score: " .. comma_value(self.score), 
			gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
	end

	if self.stopInputTimer <= 0.5 then
		if self.fadeTextColor[4] ~= 1 then
			self.fadeTextColor = 1 - 2 * self.stopInputTimer
		end
		love.graphics.printf("Press [down triangle] to return", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
	end
end
