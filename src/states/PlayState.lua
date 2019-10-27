PlayState = {}
PlayState.__index = PlayState

function PlayState:newPad(pX, pY, pRadius, pNum)
	color = self.palette.pad1
	if pNum % 2 == 1 then
		color = self.palette.pad2
	end
	table.insert(self.pads, Pad:init({
		x = pX, 
		y = pY, 
		radius = pRadius,
		padColor = color,
		index = pNum
		})
	)
	local lane11 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum), 8),
		laneColor = self.palette.laneColor
	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+1), 8),
		laneColor = self.palette.laneColor
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+2), 8),
		laneColor = self.palette.laneColor
	})
	table.insert(self.lanes, lane13)
end
--noteType: 1: bottom, 2: top, 3: both
function PlayState:newNote(nRadius, pad, lane, nSpeed, nNoteType)
	local nLane = self.lanes[lane]
	table.insert(self.notes, Note:init({
			x = nLane.endpointX,
			y = nLane.endpointY,
			radius = nRadius,
			pad = pad,
			lane = lane,
			speed = nSpeed,
			noteType = nNoteType
		})
	)
end

function PlayState:makePads()
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
end

function PlayState:enter(params)
	self.palette = params.palette or gPalette["standard"]
  
  self.pads = {}
	self.lanes = {}
  self.healthBar = HealthBar:init({healthColor = self.palette.healthColor})
	self.notes = {}
	
	self:makePads()
  
  

	--needs a way to pass in midi file
	gMidiReader = MidiReader:init("maps/drop_in_flip_out_map_tempo.mid")
	gMapNotes = gMidiReader:get_notes()
	self.delay_before_notes = 2.7
	self.note_time_multiplier = 120/176

	--DELAY BEFORE NOTES ENTER - make it longer to make them come sooner
	self.timer = self.delay_before_notes
	self.noteIndex = 1

	gAudioPlayer:stopAudio()
	gAudioPlayer:changeAudio(love.audio.newSource("sfx/Drop_In_Flip_Out.mp3", "stream"))
	gAudioPlayer:setLooping(false)
	gAudioPlayer:playAudio()
end

function PlayState:init()
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	setmetatable(PlayState, BaseState) -- inheritance: arg a inherits arg b
	
	return table.deepcopy(o)
end

function PlayState:spawnNote() --for testing, for now
	local rand = math.random(24)
	self:newNote(20, rand, 200, 1)
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
			if pad.selected then
				pad:onPress("bothArrows")
				break
			end
		end
	elseif love.keyboard.wasInput("topArrow") then
		for k, pad in pairs(self.pads) do
			if pad.selected then
				pad:onPress("topArrow")
				break
			end
		end
	elseif love.keyboard.wasInput("bottomArrow") then
		for k, pad in pairs(self.pads) do
			if pad.selected then
				pad:onPress("bottomArrow")
				break
			end
		end
	end
		
	-- Pad/note collision
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
	
	-- Debug: spawning notes
	if love.keyboard.wasInput("unbound") then
		self:spawnNote()
	end
	
	for k, note in pairs(self.notes) do
		note:update(dt)
		-- Change directions of notes once they reach center of pad
		if note.lane ~= 2 and not note.directionChanged then
			local pad = note.pad
			if (note.noteAngle == 4 or note.noteAngle == 8) then
				-- Try changing based on x position, since the note travels horizontally
				if note.dx > 0 and self.pads[pad].x <= note.x then
					note:changeDirection()
				elseif note.dx < 0 and self.pads[pad].x >= note.x then
					note:changeDirection()
				end
			else 
				-- Otherwise, try changing based on y position.
				if note.dy > 0 and self.pads[pad].y <= note.y then
					note:changeDirection()
				elseif note.dy < 0 and self.pads[pad].y >= note.y then
					note:changeDirection()
				end
			end
		end
		-- Health bar/note collision
		if circleCollision(note.x, note.y, note.radius, self.healthBar.x, self.healthBar.y, self.healthBar.radius - 2.25 * note.radius) then
			note.isDestroyed = true
			self.healthBar:takeDamage(note.score)
		end
		if note.isDestroyed then
			table.remove(self.notes, k)
		end
	end

	for k, pad in pairs(self.pads) do
		pad:update(dt)
	end

	self.timer = self.timer + dt
	--print(self.timer)
	if self.noteIndex <= #gMapNotes and self.timer >= gMapNotes[self.noteIndex].start_time * self.note_time_multiplier then
		--print(gMapNotes[self.noteIndex].pad)
		self:newNote(20, gMapNotes[self.noteIndex].pad, gMapNotes[self.noteIndex].lane, 500, 1)
		self.noteIndex = self.noteIndex + 1
	end

  --[[
	if love.keyboard.wasInput("unbound") then
		self:spawnNote()
	end
  ]]

	self.healthBar:update(dt)

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
end