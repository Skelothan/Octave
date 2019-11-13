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

	self.background = params.background or "spinTriangle"
	self.palette = gPalette[params.palette] or gPalette["bluepink"]

	self.menuColor = self.palette.menuColor or {0.9, 0.3, 0.6, 1}
	self.textColor = self.palette.textColor or {1, 1, 1, 1}
	--print("params.highScores:" .. params.highScores)
	self.highScores = JSONReader:init(params.highScores).data["highScores"] or {}
	if type(self.highScores) ~= "table" then self.highScores = {} end
	--self.highScores = JSONReader:init(params.highScores).data or {}
	self.highScoreFile = params.highScores .. "/highScores.json"
	-- is self.highScoreFile even being used? It's also inaccurate.
	self.midi = params.midi
	self.speedCoeff = params.speedCoeff
	self.noteDelay = params.noteDelay
	self.audio = params.audio
	self.bpm = params.bpm
	self.audioDelay = params.audioDelay

	
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

	local star = {}

	for i=1,5 do
		star[4*i-3] = winWidth/48*math.sin(math.pi+i*2*math.pi/5) *3/4
		star[4*i-2] = winWidth/48*math.cos(math.pi+i*2*math.pi/5) *3/4
		star[4*i-1] = winWidth/96*math.sin(math.pi+math.pi/5+i*2*math.pi/5) *3/4
		star[4*i] = winWidth/96*math.cos(math.pi+math.pi/5+i*2*math.pi/5) *3/4
	end

	local image = love.graphics.newImage(self.image)
	local scaleX = winWidth/6/image:getWidth()
	local scaleY = winWidth/6/image:getHeight()

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
	love.graphics.setLineWidth(5)

	for i = 0, self.difficulty-1, 1 do
		localStar = table.deepcopy(star)
		for j=1,20 do
			if j%2 == 1 then
				localStar[j] = localStar[j] + imageX - winWidth/32 + (3*i*winWidth/64*5/6) + 40
			else
				localStar[j] = localStar[j] +textY + 70 + 40
			end
		end
		love.graphics.polygon("line", localStar)
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
	--print("self.highScoreFile: " .. self.highScoreFile)
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