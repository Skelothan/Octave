Song = {}
Song.__index = Song

function Song:init(params)
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	
	name = params.name or "Song Name"
	artist = "Artist Name"
	--image = love.graphics.newImage("graphics/noteImage.png"), 
	difficulty = params.difficulty or 4
	menuColor = params.menuColor or {0.9, 0.3, 0.6, 1}
	textColor = params.menuColor or {1, 1, 1, 1}
	highScores = params.highScores or {}
	
	return table.deepcopy(o)
end

function Song:render(index, opacity, isCurrentSong)
	self:renderSong(index, opacity)
	if isCurrentSong then
		self:renderLeft(1)
		self:renderRight(1)
	end
end

function Song:renderSong(index, opacity)
	local songWidth = (winWidth/3) - (winWidth/32)
	local songHeight = (winHeight/6) - (winHeight/32)
	local songX = (winWidth * 0.5) - (songWidth*0.5)
	local songY = (winHeight*0.5) - (songHeight*0.5) + ((index - self.currentSong) * (songHeight + winHeight/32))

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
		self.name,
		gFonts["AvenirLight32"],
		songX + (songWidth/16),
		songY + (songHeight/16)
	)
	love.graphics.print(
		self.artist,
		gFonts["AvenirLight16"],
		songX + (songWidth/16),
		songY + (songHeight/16) + 40
	)
end

function Song:renderLeft(opacity)
	--local scaleX = winWidth/6/self.image:getWidth()
	--local scaleY = winWidth/6/self.image:getHeight()
	local imageX = (winWidth/6) - (winWidth/6/2)
	local imageY = (winHeight/4) 
	local textY = (winHeight*0.5)

	local star = love.graphics.newImage("graphics/star.png")
	local starScaleX = (winWidth/24)/star:getWidth()
	local starScaleY = (winWidth/24)/star:getHeight()

	self.menuColor[4] = opacity
	self.textColor[4] = opacity
	love.graphics.setColor(menuColor)
	love.graphics.rectangle(
		"fill",
		imageX - 3 * winWidth/64,
		imageY - winWidth/32,
		winWidth/3 - winWidth/16,
		winHeight/2
	)
	love.graphics.setColor(1,1,1,opacity)
	--love.graphics.draw(self.image, imageX, imageY, 0, scaleX, scaleY, 0, 0)

	love.graphics.setColor(textColor)
	love.graphics.print(
		self.name,
		gFonts["AvenirLight32"],
		imageX - winWidth/32,
		textY
	)
	love.graphics.print(
		self.artist,
		gFonts["AvenirLight16"],
		imageX - winWidth/32,
		textY + 40
	)

	love.graphics.setColor(1,1,1, opacity)

	for i = 0, self.difficulty-1, 1 do
		love.graphics.draw(star, imageX - winWidth/32 + (3*i*winWidth/64), textY + 70, 0, starScaleX, starScaleY, 0, 0)
	end
end

function Song:renderRight(opacity) 
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
	for i, score in ipairs(self.highScores) do
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