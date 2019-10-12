MenuState = {}
MenuState.__index = MenuState

function MenuState:init()
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self

  setmetatable(MenuState, BaseState) -- inheritance: arg a inherits arg b	
  
	self.songs = {}
	self.currentSong = 1

	-- TODO: reading this data from JSON
	local song1 = {
		name = "Song Name",
		artist = "Artist Name",
		image = love.graphics.newImage("graphics/noteImage.png"), 
		difficulty = 4,
		menuColor = {0.9, 0.3, 0.6, 1},
		textColor = {1, 1, 1, 1},
		highScores = { 
			{name = "Score Name", score = 42069},
			{name = "Bob", score = 19800},
			{name = "Ted", score = 15256} 
		}
	}
	local song2 = {
		name = "Song 2",
		artist = "Artist 2",
		image = love.graphics.newImage("graphics/songImage.jpg"),
		difficulty = 3,
		menuColor = {0.5, 0.5, 0.5, 1},
		textColor = {1, 1, 1, 1},
		highScores = {
			{name = "Score Name", score = 1234},
			{name = "Anon", score = 452}
		}
	}
	local song3 = {
		name = "Song 3",
		artist = "Artist 3",
		image = love.graphics.newImage("graphics/noteImage.png"),
		difficulty = 1,
		menuColor = nil,
		textColor = nil,
		highScores = {}
	}
	table.insert(self.songs, song1)
	table.insert(self.songs, song2)
	table.insert(self.songs, song3)
	self.numSongs = 3

	self.menuColor = self.songs[self.currentSong].menuColor or {1,1,1,1}
	self.textColor = self.songs[self.currentSong].textColor or {0, 0, 0, 1}
	self.lastUp = 0
	self.lastDown = 0
	return o
end

function MenuState:update(dt)
	self.lastUp = self.lastUp + dt
	self.lastDown = self.lastDown + dt

	if self.lastUp >= 0.15 and love.keyboard.isDown("w") and self.currentSong > 1 then
		self.currentSong = self.currentSong - 1
		self.lastUp = 0
	elseif self.lastDown >= 0.15 and love.keyboard.isDown("s") and self.currentSong < self.numSongs then
		self.currentSong = self.currentSong + 1
		self.lastDown = 0
	end
	return table.deepcopy(o)
end

function MenuState:update(dt)
	if love.keyboard.wasInput("topArrow") then
		gStateMachine:change("play", {})

	end
end


function MenuState:render()
	for i, song in ipairs(self.songs) do 
		if i == self.currentSong then 
			self.menuColor = song.menuColor or {1,1,1,1}
			self.textColor = song.textColor or {0,0,0,1}
		end
		renderSong(song, i, 0.85/(math.abs(i-self.currentSong)+1), self)
		if i == self.currentSong then
			renderLeft(song, 0.85/(math.abs(i-self.currentSong)+1), self)
			renderRight(song, 0.85/(math.abs(i-self.currentSong)+1), self)
		end
		
	end
end

function renderSong(song, index, opacity, self)
	local songWidth = (winWidth/3) - (winWidth/32)
	local songHeight = (winHeight/6) - (winHeight/32)
	local songX = (winWidth * 0.5) - (songWidth*0.5)
	local songY = (winHeight*0.5) - (songHeight*0.5) + ((index- self.currentSong) * (songHeight + winHeight/32))

	local menuColor = self.menuColor
	menuColor[4] = opacity
	local textColor = self.textColor
	textColor[4] = opacity
	love.graphics.setColor(menuColor)
	love.graphics.rectangle(
		"fill",
		songX,
		songY,
		songWidth,
		songHeight
	)

	love.graphics.setColor(self.textColor[1], self.textColor[2], self.textColor[3], opacity)
	love.graphics.print(
		song.name,
		gFonts["AvenirLight32"],
		songX + (songWidth/16),
		songY + (songHeight/16)
	)
	love.graphics.print(
		song.artist,
		gFonts["AvenirLight16"],
		songX + (songWidth/16),
		songY + (songHeight/16) + 40
	)
end

function renderLeft(song, opacity, self)
	local scaleX = winWidth/6/song.image:getWidth()
	local scaleY = winWidth/6/song.image:getHeight()
	local imageX = (winWidth/6) - (winWidth/6/2)
	local imageY = (winHeight/4) 
	local textY = (winHeight*0.5)

	local star = love.graphics.newImage("graphics/star.png")
	local starScaleX = winWidth/24/star:getWidth()
	local starScaleY = winWidth/24/star:getHeight()

	local menuColor = self.menuColor
	menuColor[4] = opacity
	local textColor = self.textColor
	textColor[4] = opacity
	love.graphics.setColor(menuColor)
	love.graphics.rectangle(
		"fill",
		imageX - 3* winWidth/64,
		imageY - winWidth/32,
		winWidth/3 - winWidth/16,
		winHeight/2
	)
	love.graphics.setColor(1,1,1,opacity)
	love.graphics.draw(song.image, imageX, imageY, 0, scaleX, scaleY, 0, 0)

	love.graphics.setColor(textColor)
	love.graphics.print(
		song.name,
		gFonts["AvenirLight32"],
		imageX - winWidth/32,
		textY
	)
	love.graphics.print(
		song.artist,
		gFonts["AvenirLight16"],
		imageX - winWidth/32,
		textY + 40
	)

	love.graphics.setColor(1,1,1, opacity)

	for i = 0, song.difficulty-1, 1 do
		love.graphics.draw(star, imageX - winWidth/32 + (3*i*winWidth/64), textY + 70, 0, starScaleX, starScaleY, 0, 0)
	end
end

function renderRight(song, opacity, self) 
	local rectWidth = winWidth/3 - winWidth/16
	local rectHeight = winHeight/2
	local rectX = (5*winWidth/6) - (winWidth/6/2) - (3*winWidth/64)
	local rectY = (winHeight/4) - winWidth/32

	local menuColor = self.menuColor
	menuColor[4] = opacity
	local textColor = self.textColor
	textColor[4] = opacity
	love.graphics.setColor(menuColor)
	love.graphics.rectangle(
		"fill", 
		rectX, 
		rectY, 
		rectWidth, 
		rectHeight
	)
	love.graphics.setColor(textColor)
	love.graphics.print(
		"High Scores",
		gFonts["AvenirLight32"],
		rectX + winWidth/64*1.5,
		rectY + winWidth/64*1.5
	)
	for i, score in ipairs(song.highScores) do
		love.graphics.print(score.name,
			gFonts["AvenirLight16"],
			rectX + winWidth/64*1.5,
			rectY + winWidth/64*1.5 + 40 + (i-1)*20
		)
		love.graphics.printf(score.score,
			gFonts["AvenirLight16"],
			rectX+winWidth/64*1.5,
			rectY + winWidth/64*1.5 + 40 + (i-1)*20,
			rectWidth - winWidth/64*3,
			"right",
			0, 1, 1, 0, 0, 0, 0
		)
	end
end
