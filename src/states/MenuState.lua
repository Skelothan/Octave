MenuState = {}
MenuState.__index = MenuState

function MenuState:init()
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	setmetatable(MenuState, BaseState) -- inheritance: arg a inherits arg b	
	
	self.songs = {}
	
	love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
	self.numSongs = 0
	if love.filesystem.getInfo("/OctaveMaps", "directory") == false then
		love.filesystem.createDirectory("/OctaveMaps")
	end
	--JSONReader:init("maps/database.json").data["songs"]
	
	--if self.success == nil then self.success = false end
	--print(self.success)
		local files = love.filesystem.getDirectoryItems("/OctaveMaps")
		
		--print(love.filesystem.getSourceBaseDirectory() .. "/OctaveMaps")
		local usefiles = {}
		local counter = 1
		for i, file in ipairs(files) do
			--print(file)
			--TODO: replace with table.insert
			if file ~= ".DS_Store" then
				table.insert(usefiles, "OctaveMaps/" .. file)
				--print("Adding " .. usefiles[counter])
			else
				--print("Skipping .DS_Store")
			end
		end

		--JSONReader:init("maps/database.json").data["songs"]


		for i, song in ipairs(usefiles) do
			--print(song .. "/data.json")
			local params = JSONReader:init(song .. "/data.json").data
			if params and params ~= {} then
				params.directory = song .. "/"
				local s = Song:init(params)
				table.insert(self.songs, s)
				self.numSongs = self.numSongs + 1
			end
		end
		print(self.numSongs)
		if self.numSongs == 0 then
			self.success = false
		else
			self.success = true
		end

		--love.filesystem.unmount(love.filesystem.getSourceBaseDirectory());
		
		if self.success then
			self.currentSong = gCurrentSong or 1
			print(self.currentSong)

			gCurrentPalette = self.songs[self.currentSong].palette
			gBackground = Background:init(self.songs[self.currentSong].background)
			-- print("test")
			self.menuColor = self.songs[self.currentSong].menuColor or {1,1,1,1}
			self.textColor = self.songs[self.currentSong].textColor or {0, 0, 0, 1}
		else			
			-- print("test2")
		end
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
	if self.movedDown then
		self.menuOffset = math.min(0, self.menuOffset + self.maxMenuOffset * 4 * dt)
	else
		self.menuOffset = math.max(0, self.menuOffset - self.maxMenuOffset * 4 * dt)
	end
	
	--if self.success then
		if self.submenu.active then
			self:updateSubmenu(dt)
		else
			self:updateNormal(dt)
		end
	--end
	
	self.lastUp = math.min(self.lastUp + dt, 0.15)
	self.lastDown = math.min(self.lastDown + dt, 0.15)
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
	
	if self.success and love.keyboard.wasInput("bottomArrow") then
		if (self.songs[self.currentSong].midi ~= nil and self.songs[self.currentSong].audio ~= nil and self.songs[self.currentSong].bpm ~= 0) then
			gSounds["start"]:stop()
			gSounds["start"]:play()
			self.submenu:updateColor()
			self.submenu:activate()
			self.submenu.selectedOption = 1
		else
			gSounds["noteMiss"]:stop()
			gSounds["noteMiss"]:play()
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
	if not self.success then
		love.graphics.setColor({1,1,1,1})
		love.graphics.printf("No maps found!", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), "center")
	else
		for i, song in ipairs(self.songs) do 
			local opacity = 0.85/(math.abs(i-self.currentSong)+1)

		if i == self.currentSong then		
			song:render(i, self.currentSong, opacity, true, self.menuOffset)
		end

			song:render(i, self.currentSong, opacity, false, self.menuOffset)
		end
	end
	
	if self.submenu.active then
		self.submenu:render()
	end
	
	love.graphics.resetColor()
	--love.graphics.printf("lastDown: " .. self.lastDown, 0, 0, winWidth, "left")
end
