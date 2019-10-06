MenuState = {}
MenuState.__index = MenuState

local songs = {}
local currentSong = 1
local numSongs = 3

local winWidth = love.graphics.getWidth()
local winHeight = love.graphics.getHeight()

function MenuState:init()
	local o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	setmetatable(MenuState, BaseState) -- inheritance: arg a inherits arg b

	table.insert(songs, newSong(
		"Song Name",
		"Artist Name",
		love.graphics.newImage("images//noteImage.png"), 
		4,
		{ newScore("Score Name", 42069),
			newScore("Bob", 19800),
			newScore("Ted", 15256) })
	)
	table.insert(songs, newSong(
		"Song 2",
		"Artist 2",
		love.graphics.newImage("images//songImage.jpg"),
		3,
		{ newScore("Score Name", 1234),
			newScore("Anon", 452) })
	)
	table.insert(songs, newSong(
		"Song 3",
		"Artist 3",
		love.graphics.newImage("images//noteImage.png"),
		1,
		{})
	)
	return o
end

function MenuState:update(dt)
	
end

function MenuState:render()
	for i, song in ipairs(songs) do 
		renderSong(song, i)
		if i == currentSong then 
			renderLeft(song)
			renderRight(song)
		end
	end
end

function renderSong(song, index)
	local songWidth = (winWidth/3) - (winWidth/32)
	local songHeight = (winHeight/6) - (winHeight/32)
	local songX = (winWidth * 0.5) - (songWidth*0.5)
	local songY = (winHeight*0.5) - (songHeight*0.5) + ((index-currentSong) * (songHeight + winHeight/32))

	love.graphics.setColor(0.9, 0.3, 0.6, 1/(math.abs(index-currentSong)+1))
	love.graphics.rectangle(
		"fill",
		songX,
		songY,
		songWidth,
		songHeight
	)
	love.graphics.setColor(1,1,1,1)
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

function renderLeft(song)
	local scaleX = winWidth/6/song.image:getWidth()
	local scaleY = winWidth/6/song.image:getHeight()
	local imageX = (winWidth/6) - (winWidth/6/2)
	local imageY = (winHeight/4) 
	local textY = (winHeight*0.5)

	local star = love.graphics.newImage("images//star.png")
	local starScaleX = winWidth/24/star:getWidth()
	local starScaleY = winWidth/24/star:getHeight()

	love.graphics.setColor(0.9, 0.3, 0.6, 1)
	love.graphics.rectangle(
		"fill",
		imageX - 3* winWidth/64,
		imageY - winWidth/32,
		winWidth/3 - winWidth/16,
		winHeight/2
	)

	love.graphics.draw(song.image, imageX, imageY, 0, scaleX, scaleY, 0, 0)

	love.graphics.setColor(1,1,1,1)
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

	for i = 0, song.difficulty-1, 1 do
		love.graphics.draw(star, imageX - winWidth/32 + (3*i*winWidth/64), textY + 70, 0, starScaleX, starScaleY, 0, 0)
	end
end

function renderRight(song) 
	local rectWidth = winWidth/3 - winWidth/16
	local rectHeight = winHeight/2
	local rectX = (5*winWidth/6) - (winWidth/6/2) - (3*winWidth/64)
	local rectY = (winHeight/4) - winWidth/32

	love.graphics.setColor(0.9, 0.3, 0.6, 1)
	love.graphics.rectangle(
		"fill", 
		rectX, 
		rectY, 
		rectWidth, 
		rectHeight
	)
	love.graphics.setColor(1,1,1,1)
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


function newSong(name, artist, image, difficulty, highScores)
	return {
		name = name,
		artist = artist,
		image = image,
		difficulty = difficulty,
		highScores = highScores
	}
end

function newScore(name, score)
	return {
		name = name,
		score = score
	}
end

function love.keyreleased( key )
   if (key == "r" or key == "t") and currentSong > 1 then 
		currentSong = currentSong - 1
	elseif (key == "g" or key == "f") and currentSong < numSongs then
		currentSong = currentSong + 1
	end
end