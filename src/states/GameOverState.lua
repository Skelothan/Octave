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
	self.stopInputTimer = 0.5
	self.song = params.song

	self.currChar = 65
	self.choosingName = (self.isWon and not params.practice) or self.debug
	self.practice = params.practice
	self.scoreName = ""
	self.showStats = not self.choosingName
	self.maxLetters = 6
	self.debug = false

	self.lastUp = 0
	self.lastDown = 0
	
	self.stats = params.stats

	-- Play victory music if the game was won
	if self.isWon then
		gSounds["victory"]:stop()
		gSounds["victory"]:play()
	end

	self.top = Note:init({
		x = love.graphics.getWidth()/8*3 + 60,
		y = love.graphics.getHeight()*0.75 - 25 + 20,
		radius = 20,
		pad = 1,
		lane = 1,
		speed = 0,
		noteType = 2,
		score = 1
	})
	self.bottom = Note:init({
		x = love.graphics.getWidth()/8*3 + 60,
		y = love.graphics.getHeight()*0.75 + 35,
		radius = 20,
		pad = 1,
		lane = 1,
		speed = 1,
		noteType = 1,
		score = 1
	})
	self.bottom2 = Note:init({
		x = love.graphics.getWidth()/8*3 + 110,
		y = love.graphics.getHeight()*0.85 + 20,
		radius = 20,
		pad = 1,
		lane = 1,
		speed = 1,
		noteType = 1,
		score = 1
	})
end

function sortScores(s1, s2)
	return s1.score > s2.score
end

function GameOverState:update(dt)
	self.lastUp = math.min(self.lastUp + dt, 0.15)
	self.lastDown = math.min(self.lastDown + dt, 0.15)

	self.stopInputTimer = math.max(self.stopInputTimer - dt, 0)
	-- Downwards scrolling letter selection
	if self.choosingName and self.lastDown >= 0.15 and love.keyboard.isHeld("down") then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
		
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
		self.lastDown = 0
	-- Upwards scrolling letter selection
	elseif self.choosingName and self.lastUp >= 0.15 and love.keyboard.isHeld("up") then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
		
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
		self.lastUp = 0
	-- Confirm letter
	elseif self.choosingName and love.keyboard.wasInput("bottomArrow") then
		gSounds["noteHitOk"]:stop()
		gSounds["noteHitOk"]:play()
		
		self.scoreName = self.scoreName .. string.char(self.currChar)
		self.currChar = 97
		if string.len(self.scoreName) == self.maxLetters then
			self.choosingName = false
		end
	-- Delete letter
	elseif love.keyboard.wasInput("topArrow") then
		if string.len(self.scoreName) > 0 then
			gSounds["noteMiss"]:stop()
			gSounds["noteMiss"]:play()
			self.choosingName = true
			self.showStats = false
			self.scoreName = string.sub(self.scoreName, 1, string.len(self.scoreName)-1)
			if string.len(self.scoreName) == 0 then
				self.currChar = 65
			else
				self.currChar = 97
			end
		else
			gSounds["back"]:stop()
			gSounds["back"]:play()
		end
	end
	-- Confirm name, leave GameOverState
	if self.stopInputTimer <= 0 and (love.keyboard.wasInput("togglePauseMenu") or 
		(not self.choosingName and love.keyboard.wasInput("bottomArrow"))) then
		if self.showStats then 
			if self.isWon then 
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
			gAudioPlayer:changeAudio(gMenuMusic)
			gAudioPlayer:setLooping(true)
			gAudioPlayer:playAudio()
			gSounds["victory"]:stop()
			gStateMachine:change("menu", {})
		else 
			gSounds["start"]:stop()
			gSounds["start"]:play()
			self.choosingName = false
			self.showStats = true
		end
	end

end

function GameOverState:render()
	love.graphics.setColor(gCurrentPalette.menuText)
	
	if self.isWon then
		love.graphics.printf("You Win!", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center")
	else
		love.graphics.printf("Game Over", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center")
	end

	if self.showStats then
		self:renderStats()
	else
		self:renderHighScoreInput()
	end
end

function GameOverState:renderHighScoreInput()

	-- Name entry box
	love.graphics.printf("Enter your name: ", gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 - 50, love.graphics.getWidth(), "center")
	love.graphics.rectangle(
		"line",
		love.graphics.getWidth()/2 - love.graphics.getWidth() / 12,
		love.graphics.getHeight() / 2, 
		love.graphics.getWidth() / 6,
		50
	)
	
	-- Controls
	if self.choosingName then
		--love.graphics.printf("Controls: ", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 - 65, love.graphics.getWidth(), "center")
		love.graphics.printf("Joystick to scroll through letters", gFonts["AvenirLight32"], love.graphics.getWidth()/8*3, love.graphics.getHeight()*0.75 - 75, love.graphics.getWidth(), "left")
		self.top:render()
		self.bottom:render()
		love.graphics.setColor(gCurrentPalette.menuText)
		love.graphics.printf(" to backspace", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 - 30, love.graphics.getWidth(), "center")
		love.graphics.printf(" to set letter", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 + 15, love.graphics.getWidth()-20, "center")
		love.graphics.printf("Pause to set name", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 + 60, love.graphics.getWidth(), "center")
		love.graphics.printf(self.scoreName .. string.char(self.currChar), 
			gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
	else
		love.graphics.printf(self.scoreName, gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
		self.bottom.x = love.graphics.getWidth()/8*3 + 110
		self.bottom.y = love.graphics.getHeight()*0.75 + 20
		self.bottom:render()
		love.graphics.printf(" to continue", gFonts["AvenirLight32"], 20, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
	end
	
	love.graphics.printf("Your Score: " .. comma_value(self.score), 
		gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + love.graphics.getHeight() / 12, love.graphics.getWidth(), "center")
	
end

function GameOverState:renderStats()
	love.graphics.printf("Your Score: " .. comma_value(self.score), 
	gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.4, love.graphics.getWidth(), "center")
	
	local counter = 1
	local height = gFonts["AvenirLight24"]:getHeight()
	
	love.graphics.printf("Stats", gFonts["AvenirLight24"], 0, love.graphics.getHeight()*0.50, love.graphics.getWidth(), "center")
	for k, accuracy in ipairs({"Perfect", "Great", "Good", "OK", "Miss", "Hurt"}) do
		love.graphics.printf(accuracy .. ":", gFonts["AvenirLight24"], 0, love.graphics.getHeight()*0.50+counter*1.1*height, love.graphics.getWidth()/2, "right")
		love.graphics.printf("    " .. tostring(self.stats[accuracy]), gFonts["AvenirLight24"], love.graphics.getWidth()/2, love.graphics.getHeight()*0.50+counter*1.1*height, love.graphics.getWidth()/2, "left")
		counter = counter + 1
	end
	
	self.bottom2:render()
	love.graphics.setColor(gCurrentPalette.menuText)
	love.graphics.printf(" to return", gFonts["AvenirLight32"], 20, love.graphics.getHeight()*0.85, love.graphics.getWidth(), "center")
end
