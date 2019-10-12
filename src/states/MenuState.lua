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
	local song1 = Song:init({
		name = "Song Name",
		artist = "Artist Name",
		--image = love.graphics.newImage("graphics/noteImage.png"), 
		difficulty = 4,
		menuColor = {0.9, 0.3, 0.6, 1},
		textColor = {1, 1, 1, 1},
		highScores = { 
			{name = "Score Name", score = 42069},
			{name = "Bob", score = 19800},
			{name = "Ted", score = 15256} 
		}
	})
	local song2 = Song:init({
		name = "Song 2",
		artist = "Artist 2",
		--image = love.graphics.newImage("graphics/songImage.jpg"),
		difficulty = 3,
		menuColor = {0.5, 0.5, 0.5, 1},
		textColor = {1, 1, 1, 1},
		highScores = {
			{name = "Score Name", score = 1234},
			{name = "Anon", score = 452}
		}
	})
	local song3 = Song:init({
		name = "Song 3",
		artist = "Artist 3",
		--image = love.graphics.newImage("graphics/noteImage.png"),
		difficulty = 1,
		menuColor = nil,
		textColor = nil,
		highScores = {}
	})
	table.insert(self.songs, song1)
	table.insert(self.songs, song2)
	table.insert(self.songs, song3)
	self.numSongs = 3

	self.menuColor = self.songs[self.currentSong].menuColor or {1,1,1,1}
	self.textColor = self.songs[self.currentSong].textColor or {0, 0, 0, 1}
	self.lastUp = 0
	self.lastDown = 0
	
	return table.deepcopy(o)
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
		song:render(i, 0.85/(math.abs(i-self.currentSong)+1))
		renderSong(song, i, 0.85/(math.abs(i-self.currentSong)+1), self)
		if i == self.currentSong then
			renderLeft(song, 0.85/(math.abs(i-self.currentSong)+1), self)
			renderRight(song, 0.85/(math.abs(i-self.currentSong)+1), self)
		end
		
	end
end
