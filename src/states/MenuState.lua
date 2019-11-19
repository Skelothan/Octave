MenuState = {}
MenuState.__index = MenuState

function MenuState:init()
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	
	setmetatable(MenuState, BaseState) -- inheritance: arg a inherits arg b	
	
	self.songs = {}
	self.numSongs = 0

	local files = love.filesystem.getDirectoryItems("/maps")
	local usefiles = {}
	local counter = 1
	for i, file in ipairs(files) do
		--print(file)
		--TODO: replace with table.insert
		if file ~= ".DS_Store" then
			usefiles[counter] = "maps/" .. file
			--print("Adding " .. usefiles[counter])
			counter = counter + 1
		else
			--print("Skipping .DS_Store")
		end
	end
	--JSONReader:init("maps/database.json").data["songs"]


	for i, song in ipairs(usefiles) do
		--print(song .. "/data.json")
		local params = JSONReader:init(song .. "/data.json").data
		if params and params ~= {} then
			params["directory"] = song .. "/"
			local s = Song:init(params)
			table.insert(self.songs, s)
			self.numSongs = self.numSongs + 1
		end
	end

	self.currentSong = gCurrentSong

	gCurrentPalette = self.songs[self.currentSong].palette
	gBackground = Background:init(self.songs[self.currentSong].background)

	self.menuColor = self.songs[self.currentSong].menuColor or {1,1,1,1}
	self.textColor = self.songs[self.currentSong].textColor or {0, 0, 0, 1}
	self.lastUp = 0
	self.lastDown = 0
	
	
	self.maxMenuOffset = love.graphics.getHeight() / 72
	self.menuOffset = 0
	self.movedDown = true

	return table.deepcopy(o)
end

function MenuState:enter(params)
	self.submenu = Submenu:init({
		
		x = (5*winWidth/6) - (winWidth/12) - (3*winWidth/64),
		y = winHeight * 25/32,
		width = winWidth/3 - winWidth/16,
		font = "AvenirLight32",
		align = "left",
		
		selectedOption = 1,
		
		options = {
			{"Play", 
			function() 
				local menustate = gStateMachine.current
				gSounds["startExt"]:stop()
				gSounds["startExt"]:play()
				gStateMachine:change("play", {song = menustate.songs[menustate.currentSong]})
			end},
			{"Practice", 
			function() 
				local menustate = gStateMachine.current
				gSounds["startExt"]:stop()
				gSounds["startExt"]:play()
				gStateMachine:change("play", {song = menustate.songs[menustate.currentSong], practice = true})
			end},
			{"Back", 
			function() 
				gSounds["back"]:stop()
				gSounds["back"]:play()
				gStateMachine.current.submenu.active = false 
			end}
		}
	})
end 


function MenuState:update(dt)
	self.lastUp = self.lastUp + dt
	self.lastDown = self.lastDown + dt
	
	if self.movedDown then
		self.menuOffset = math.min(0, self.menuOffset + self.maxMenuOffset * 4 * dt)
	else
		self.menuOffset = math.max(0, self.menuOffset - self.maxMenuOffset * 4 * dt)
	end
	
	if self.submenu.active then
		self:updateSubmenu(dt)
	else
		self:updateNormal(dt)
	end
end

function MenuState:updateNormal(dt)
	

	if self.lastUp >= 0.15 and love.keyboard.isHeld("up") and self.currentSong > 1 then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
		self.currentSong = self.currentSong - 1

		gCurrentPalette = self.songs[self.currentSong].palette
		gBackground = Background:init(self.songs[self.currentSong].background)

		self.lastUp = 0
		
		self.menuOffset = self.maxMenuOffset
		self.movedDown = false
		
	elseif self.lastDown >= 0.15 and love.keyboard.isHeld("down") and self.currentSong < self.numSongs then
		gSounds["scroll"]:stop()
		gSounds["scroll"]:play()
		self.currentSong = self.currentSong + 1

		gCurrentPalette = self.songs[self.currentSong].palette
		gBackground = Background:init(self.songs[self.currentSong].background)

		self.lastDown = 0
		
		self.menuOffset = -self.maxMenuOffset
		self.movedDown = true
	end
	if love.keyboard.wasInput("bottomArrow") then
	 --[[
		gCurrentSong = self.currentSong
		gStateMachine:change("play", {song = self.songs[self.currentSong]})
		]]
		if (self.songs[self.currentSong].midi ~= nil and self.songs[self.currentSong].audio ~= nil and self.songs[self.currentSong].bpm ~= 0) then
			gSounds["start"]:stop()
			gSounds["start"]:play()
			self.submenu:updateColor()
			self.submenu:activate()
			self.submenu.selectedOption = 1
		else
			gSounds["miss"]:stop()
			gSounds["miss"]:play()
		end
	end
	if love.keyboard.wasInput("topArrow") then
		gSounds["back"]:stop()
		gSounds["back"]:play()
		gStateMachine:change("title", {selectedOption = 1, submenuActive = true})
	end
end

function MenuState:updateSubmenu(dt)
	if love.keyboard.wasInput("up") then
		self.submenu:up()
	elseif love.keyboard.wasInput("down") then
		self.submenu:down()
	end
	
	if love.keyboard.wasInput("topArrow") then
		gSounds["back"]:stop()
		gSounds["back"]:play()
		self.submenu:deactivate()
	elseif love.keyboard.wasInput("bottomArrow") then
		self.submenu:select()
	end
end

function MenuState:render()
	for i, song in ipairs(self.songs) do 
		local opacity = 0.85/(math.abs(i-self.currentSong)+1)

		if i == self.currentSong then		
			song:render(i, self.currentSong, opacity, true, self.menuOffset)
		end

		song:render(i, self.currentSong, opacity, false, self.menuOffset)
	end
	
	if self.submenu.active then
		self.submenu:render()
	end
end
