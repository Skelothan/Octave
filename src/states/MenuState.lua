MenuState = {}
MenuState.__index = MenuState

function MenuState:init()
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	
	setmetatable(MenuState, BaseState) -- inheritance: arg a inherits arg b	
	
	self.songs = {}
	self.currentSong = 1
	self.numSongs = 0	
	
	local files = love.filesystem.getDirectoryItems("/maps")
	for i, file in ipairs(files) do
		files[i] = "maps/" .. file
	end
	--JSONReader:init("maps/database.json").data["songs"]


	for i, song in ipairs(files) do
		local params = JSONReader:init(song .. "/data.json").data
		local s = Song:init(params)
		table.insert(self.songs, s)
		self.numSongs = self.numSongs + 1
	end

	self.menuColor = self.songs[self.currentSong].menuColor or {1,1,1,1}
	self.textColor = self.songs[self.currentSong].textColor or {0, 0, 0, 1}
	self.lastUp = 0
	self.lastDown = 0
  
	return table.deepcopy(o)
end

function MenuState:enter()
end 


function MenuState:update(dt)
	self.lastUp = self.lastUp + dt
	self.lastDown = self.lastDown + dt

	if self.lastUp >= 0.15 and love.keyboard.isHeld("up") and self.currentSong > 1 then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
		self.currentSong = self.currentSong - 1
		self.lastUp = 0
	elseif self.lastDown >= 0.15 and love.keyboard.isHeld("down") and self.currentSong < self.numSongs then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
		self.currentSong = self.currentSong + 1
		self.lastDown = 0
	end
	if love.keyboard.wasInput("bottomArrow") then
		gSounds["startExt"]:stop()
		gSounds["startExt"]:play()
		gStateMachine:change("play", {song = self.songs[self.currentSong]})
	end
	if love.keyboard.wasInput("topArrow") then
		gSounds["back"]:stop()
		gSounds["back"]:play()
		gStateMachine:change("title", {})
	end
end

function MenuState:render()
	for i, song in ipairs(self.songs) do 
		local opacity = 0.85/(math.abs(i-self.currentSong)+1)

		if i == self.currentSong then 
			song:render(i, self.currentSong, opacity, true)
		end

		song:render(i, self.currentSong, opacity, false)
	end
end
