Song = {}
Song.__index = Song

function Song:init(params)
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	
	self.name = params.title or "Song Name"
	self.artist = params.artist or "Artist Name"
	self.image = params.image or "graphics/noteImage.png"
	self.difficulty = params.difficulty or 4

	self.menuColor = gCurrentPalette.menuColor or {0.9, 0.3, 0.6, 1}
	self.textColor = gCurrentPalette.textColor or {1, 1, 1, 1}
	self.highScores = JSONReader:init(params.highScores).data["highScores"] or {}
	self.highScoreFile = params.highScores .. "/highScores.json"
	self.midi = params.midi
	self.speedCoeff = params.speedCoeff
	self.audio = params.audio
	self.bpm = params.bpm
	self.audioDelay = params.audioDelay

	self.background = params.background
	self.palette = gPalette[params.palette]
	
	return table.deepcopy(o)
end

function Song:render(index, currentSong, opacity, isCurrentSong)
	self:renderSong(index, currentSong, opacity)
	if isCurrentSong then
		self:renderLeft(1)
		self:renderRight(1)
	end
end

function Song:renderSong(index, currentSong, opacity)
	local winWidth = love.graphics.getWidth()
	local winHeight = love.graphics.getHeight()
	local songWidth = (winWidth/3) - (winWidth/32)
	local songHeight = (winHeight/6) - (winHeight/32)
	local songX = (winWidth * 0.5) - (songWidth*0.5)
	local songY = (winHeight*0.5) - (songHeight*0.5) + ((index - currentSong) * (songHeight + winHeight/32))

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

	love.graphics.setColor(textColor)
	love.graphics.print(
		self.name,
		gFonts["AvenirLight32"],
		songX + (songWidth/16),
		songY + (songHeight/16)
	)
	love.graphics.print(
		self.artist,
		gFonts["AvenirLight24"],
		songX + (songWidth/16),
		songY + (songHeight/16) + 40
	)
end

function Song:renderLeft(opacity)
	local winWidth = love.graphics.getWidth()
	local winHeight = love.graphics.getHeight()

	local imageX = (winWidth/6) - (winWidth/6/2)
	local imageY = (winHeight/5) 
	local textY = (winHeight*0.5) + (winWidth/64)

	local star = love.graphics.newImage("graphics/star.png")
	local image = love.graphics.newImage(self.image)
	local scaleX = winWidth/6/image:getWidth()
	local scaleY = winWidth/6/image:getHeight()
	local starScaleX = (winWidth/24)/star:getWidth()
	local starScaleY = (winWidth/24)/star:getHeight()

	self.menuColor[4] = opacity
	self.textColor[4] = opacity
	love.graphics.setColor(self.menuColor)
	love.graphics.rectangle(
		"fill",
		imageX - 3 * winWidth/64,
		imageY - winWidth/24,
		winWidth/3 - winWidth/16,
		2*winHeight/3
	)
	love.graphics.setColor(1,1,1,opacity)
	love.graphics.draw(image, imageX, imageY, 0, scaleX, scaleY, 0, 0)

	love.graphics.setColor(self.textColor)
	love.graphics.print(
		self.name,
		gFonts["AvenirLight32"],
		imageX - winWidth/64,
		textY
	)
	love.graphics.print(
		self.artist,
		gFonts["AvenirLight24"],
		imageX - winWidth/64,
		textY + 40
	)

	love.graphics.setColor(1,1,1, opacity)

	for i = 0, self.difficulty-1, 1 do
		love.graphics.draw(star, imageX - winWidth/32 + (3*i*winWidth/64), textY + 70, 0, starScaleX, starScaleY, 0, 0)
	end
end

function Song:renderRight(opacity) 
	local winWidth = love.graphics.getWidth()
	local winHeight = love.graphics.getHeight()

	local rectWidth = winWidth/3 - winWidth/16
	local rectHeight = winHeight/2
	local rectX = (5*winWidth/6) - (winWidth/6/2) - (3*winWidth/64)
	local rectY = (winHeight/4) - winWidth/32

	self.menuColor[4] = opacity
	self.textColor[4] = opacity
	love.graphics.setColor(self.menuColor)
	love.graphics.rectangle(
		"fill", 
		rectX, 
		rectY, 
		rectWidth, 
		rectHeight
	)
	love.graphics.setColor(self.textColor)
	love.graphics.print(
		"High Scores",
		gFonts["AvenirLight32"],
		rectX + winWidth/64*1.5,
		rectY + winWidth/64*1.5
	)
	for i, score in ipairs(self.highScores) do
		love.graphics.print(score.name,
			gFonts["AvenirLight24"],
			rectX + winWidth/64*1.5,
			rectY + winWidth/64*1.5 + 40 + (i-1)*30
		)
		love.graphics.printf(score.score,
			gFonts["AvenirLight24"],
			rectX+winWidth/64*1.5,
			rectY + winWidth/64*1.5 + 40 + (i-1)*30,
			rectWidth - winWidth/64*3,
			"right",
			0, 1, 1, 0, 0, 0, 0
		)
	end
end