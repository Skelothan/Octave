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
	self.choosingName = (self.isWon and not params.practice) or self.debug
	self.practice = params.practice
	self.scoreName = ""
	self.showStats = not self.choosingName
	self.maxLetters = 6
	self.debug = false

	self.lastUp = 0
	self.lastDown = 0
end

function sortScores(s1, s2)
	return s1.score > s2.score
end

function GameOverState:update(dt)
	self.lastUp = math.min(self.lastUp + dt, 0.15)
	self.lastDown = math.min(self.lastDown + dt, 0.15)

	self.stopInputTimer = math.max(self.stopInputTimer - dt, 0)
	if self.choosingName and self.lastDown >= 0.15 and love.keyboard.isHeld("down") then
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
	elseif self.choosingName and self.lastUp >= 0.15 and love.keyboard.isHeld("up") then
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
	elseif self.choosingName and love.keyboard.wasInput("bottomArrow") then
		self.scoreName = self.scoreName .. string.char(self.currChar)
		self.currChar = 97
		if string.len(self.scoreName) == self.maxLetters then
			self.choosingName = false
		end
	elseif love.keyboard.wasInput("topArrow") then
		if string.len(self.scoreName) > 0 then
			self.choosingName = true
			self.showStats = false
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
			gAudioPlayer:changeAudio(love.audio.newSource("sfx/Welcome_to_Octave.wav", "stream"))
			gAudioPlayer:setLooping(true)
			gAudioPlayer:playAudio()
			gStateMachine:change("menu", {})
		else 
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

	if self.choosingName then
		love.graphics.printf("Enter your name: ", gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 - 50, love.graphics.getWidth(), "center")
		love.graphics.rectangle(
			"line",
			love.graphics.getWidth()/2 - love.graphics.getWidth() / 12,
			love.graphics.getHeight() / 2, 
			love.graphics.getWidth() / 6,
			50
		)
	end

	if self.choosingName or self.debug then
		--love.graphics.printf("Controls: ", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 - 65, love.graphics.getWidth(), "center")
		love.graphics.printf("[joystick] to scroll through letters", gFonts["AvenirLight32"], love.graphics.getWidth()/8*3, love.graphics.getHeight()*0.75 - 75, love.graphics.getWidth(), "left")
		local top = Note:init({
			x = love.graphics.getWidth()/8*3 + 60,
			y = love.graphics.getHeight()*0.75 - 25 + 20,
			radius = 20,
			pad = 1,
			lane = 1,
			speed = 0,
			noteType = 2,
			score = 1
		})
		local bottom = Note:init({
			x = love.graphics.getWidth()/8*3 + 60,
			y = love.graphics.getHeight()*0.75 + 15 + 20,
			radius = 20,
			pad = 1,
			lane = 1,
			speed = 0,
			noteType = 1,
			score = 1
		})
		top:render()
		bottom:render()
		love.graphics.setColor(gCurrentPalette.menuText)
		love.graphics.printf(" to backspace", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 - 30, love.graphics.getWidth(), "center")
		love.graphics.printf(" to set letter", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 + 15, love.graphics.getWidth()-20, "center")
		love.graphics.printf("[pause] to set name", gFonts["AvenirLight32"], 0, love.graphics.getHeight()*0.75 + 60, love.graphics.getWidth(), "center")
		love.graphics.printf(self.scoreName .. string.char(self.currChar), 
			gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
	elseif not self.showStats then
		love.graphics.printf(self.scoreName, gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2 + 3, love.graphics.getWidth(), "center")
		local bottom = Note:init({
			x = love.graphics.getWidth()/8*3 + 110,
			y = love.graphics.getHeight()*0.75 + 20,
			radius = 20,
			pad = 1,
			lane = 1,
			speed = 1,
			noteType = 1,
			score = 1
		})
		love.graphics.printf(" to continue", gFonts["AvenirLight32"], 20, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")

	end

	if not self.showStats then 
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
		if self.showStats then
			local bottom = Note:init({
				x = love.graphics.getWidth()/8*3 + 110,
				y = love.graphics.getHeight()*0.75 + 20,
				radius = 20,
				pad = 1,
				lane = 1,
				speed = 1,
				noteType = 1,
				score = 1
			})
			bottom:render()
			love.graphics.setColor(gCurrentPalette.menuText)	
			love.graphics.printf(" to return", gFonts["AvenirLight32"], 20, love.graphics.getHeight()*0.75, love.graphics.getWidth(), "center")
		end
	end
end
