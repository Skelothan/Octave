PlayState = {}
PlayState.__index = PlayState

function PlayState:newPad(pX, pY, pRadius, pNum)
	table.insert(self.pads, Pad:init({
		x = pX, 
		y = pY, 
		radius = pRadius,
		index = pNum
		})
	)
	local lane11 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum), 8)

	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+1), 8)
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+2), 8)
	})
	table.insert(self.lanes, lane13)
end
--noteType: 1: bottom, 2: top, 3: both
function PlayState:newNote(nRadius, nPad, nLane, nSpeed, nNoteType)
	table.insert(self.notes, Note:init({
			x = nLane.endpointX,
			y = nLane.endpointY,
			radius = nRadius,
			pad = nPad,
			lane = nLane,
			speed = nSpeed,
			noteType = nNoteType
		})
	)
end

function PlayState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayState, BaseState) -- inheritance: arg a inherits arg b
	
	self.pads = {}
	self.lanes = {}
	self.healthBar = HealthBar:init({}) -- todo: add palettes to everything
	self.notes = {}
	
	local centerRadius = math.min(love.graphics.getHeight(), love.graphics.getWidth())/8
	local pRadius = 20
	
	--Add pads:

	--bottom right
	self:newPad(love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2), pRadius, 8)

	--bottom 
	self:newPad(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + centerRadius, pRadius, 1)
	
	--bottom left
	self:newPad(love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2), pRadius, 2)
	
	--left
	self:newPad(love.graphics.getWidth()/2 - centerRadius, 
		love.graphics.getHeight()/2, pRadius, 3)
	
	--top left
	self:newPad(love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2), pRadius, 4)
	
	--top
	self:newPad(love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2- centerRadius, pRadius, 5)
	
	--top right
	self:newPad(love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2), pRadius, 6)
	
	--right
	self:newPad(love.graphics.getWidth()/2 + centerRadius, 
		love.graphics.getHeight()/2, pRadius, 7)
	
	--needs a way to pass in midi file
	gMidiReader = MidiReader:init("sfx/Test.mid")
	gMapNotes = gMidiReader:get_notes()
	self.timer = 0
	self.noteIndex = 1
	
	return table.deepcopy(o)
end

function PlayState:spawnNote() --for testing, for now
	local rand = math.random(24)
	self:newNote(30, self.pads[math.floor((rand-1)/3) + 1], self.lanes[rand], 500, 1)
end

function PlayState:update(dt) 
	for k, pad in pairs(self.pads) do
		pad.selected = false
	end

	--selecting with joystick
	if love.keyboard.isHeld("down") and love.keyboard.isHeld("left") then 
		
		self.pads[3].selected = true
	elseif love.keyboard.isHeld("up") and love.keyboard.isHeld("left") then 
		self.pads[5].selected = true
	elseif love.keyboard.isHeld("up") and love.keyboard.isHeld("right") then 
		self.pads[7].selected = true
	elseif love.keyboard.isHeld("down") and love.keyboard.isHeld("right") then 
		self.pads[1].selected = true
	elseif love.keyboard.isHeld("down") then
		self.pads[2].selected = true
	elseif love.keyboard.isHeld("left") then
		self.pads[4].selected = true
	elseif love.keyboard.isHeld("up") then
		self.pads[6].selected = true
	elseif love.keyboard.isHeld("right") then
		self.pads[8].selected = true
	end

	--actually hitting buttons
	if love.keyboard.wasInput("topArrow") and love.keyboard.wasInput("bottomArrow") then 
		for k, pad in pairs(self.pads) do
			if(pad.selected == true) then
				pad:onPress("bothArrows")
				break
			end
		end
	elseif love.keyboard.wasInput("topArrow") then
		for k, pad in pairs(self.pads) do
			if(pad.selected == true) then
				pad:onPress("topArrow")
				break
			end
		end
	elseif love.keyboard.wasInput("bottomArrow") then
		for k, pad in pairs(self.pads) do
			if(pad.selected == true) then
				pad:onPress("bottomArrow")
				break
			end
		end
	end
		
	--collision
	if love.keyboard.wasInput("topArrow") or love.keyboard.wasInput("bottomArrow") then
		for k, pad in pairs(self.pads) do
			if pad.active then
				for k, note in pairs(self.notes) do --notes is populated from within note.lua when spawned
					coll_collides, coll_dist = noteCollision(pad, note)
					if coll_collides == true and note.isHit == false then
						note:onHit()
					end
				end
			end
		end
	end



	for k, note in pairs(self.notes) do
		note:update(dt)
		if(note.isDestroyed) then
			table.remove(self.notes, k)
		end
	end
	for k, pad in pairs(self.pads) do
		pad:update(dt)
	end
	

	self.timer = self.timer + dt
	print(self.timer)
	if self.noteIndex <= #gMapNotes and self.timer >= gMapNotes[self.noteIndex].start_time then
		self:newNote(30, self.pads[1], self.lanes[2], 500, 1)
		self.noteIndex = self.noteIndex + 1
	end

	if love.keyboard.wasInput("unbound") then
		self:spawnNote()
	end

end

function PlayState:render() 
	for k, lane in pairs(self.lanes) do
		lane:render()
	end
	for k, pad in pairs(self.pads) do
		pad:render()
	end
	for k, note in pairs(self.notes) do
		note:render()
	end
	self.healthBar:render()
	for k, note in pairs(self.notes) do
		note:render()
	end
end