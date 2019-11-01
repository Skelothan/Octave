PlayState = {}
PlayState.__index = PlayState

function PlayState:newPad(pX, pY, pRadius, pNum)
	color = gCurrentPalette.pad1
	if pNum % 2 == 1 then
		color = gCurrentPalette.pad2
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
		laneColor = gCurrentPalette.laneColor
	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+1), 8),
		laneColor = gCurrentPalette.laneColor
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+2), 8),
		laneColor = gCurrentPalette.laneColor
	})
	table.insert(self.lanes, lane13)
end
--noteType: 1: bottom, 2: top, 3: both
function PlayState:newNote(nRadius, pad, lane, nNoteType)
	local nLane = self.lanes[lane]
	table.insert(self.notes, Note:init({
			x = noteSpawnCoords[lane][1],
			y = noteSpawnCoords[lane][2],
			radius = nRadius,
			pad = pad,
			lane = lane,
			speed = self.noteSpeed,
			noteType = nNoteType
		})
	)
end

function PlayState:makePads()
	--local centerRadius = math.min(love.graphics.getHeight(), love.graphics.getWidth())/8
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
	self.pads = {}
	self.lanes = {}
	self.healthBar = HealthBar:init({healthColor = gCurrentPalette.healthColor})
	self.notes = {}
	
	-- Note speed must be constant for correct syncing
	self.noteSpeed = 0.3 * math.max(love.graphics.getHeight(), love.graphics.getWidth())
	
	self:makePads()
	

	--needs a way to pass in midi file
	gMidiReader = MidiReader:init("maps/drop_in_flip_out_map_tempo_noleadin.mid")
	gMapNotes = gMidiReader:get_notes()
	--[[
	for k, note in pairs(gMapNotes) do
		print(note.start_time)
	end
	]]

	-- Was originally necessary because there was lead-in time in the MIDI. We no longer use lead-in time.
	self.delay_before_notes = 0
	--self.note_time_multiplier = 100/176
	--self.note_time_multiplier = 120/176
	
	-- This coefficient converts the time units in the score to seconds. Luckily, it seems to be constant per file.
	self.note_time_multiplier = 0.7102 --derived with excel, logic pro, and pain. Works for Drop In, Flip Out at least...
	-- For this track, seems to be equal to 125 / BPM
	
	--print("Delay before notes: " .. self.delay_before_notes)
	
	self.note_travel_time = ((gSpawnDistance - centerRadius) / self.noteSpeed)
	
	--print("Note travel time: " .. (gSpawnDistance / self.noteSpeed))

	--DELAY BEFORE NOTES ENTER - make it longer to make them come sooner
	self.timer = self.delay_before_notes
	self.noteIndex = 1
	
	self.audioStarted = false
	gAudioPlayer:stopAudio()
	-- Delay before audio syncs to MIDI for Drop In, Flip Out: 85 milliseconds, more or less exactly
	self.audioDelay = 2 * 0.085 + self.note_travel_time + self.delay_before_notes -- TODO: read from JSON
	gAudioPlayer:changeAudio(love.audio.newSource("sfx/Drop_In_Flip_Out.mp3", "stream"))
	gAudioPlayer:setLooping(false)
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
	
	self.audioDelay = math.max(self.audioDelay-dt, 0)
	if self.audioDelay == 0 and not self.audioStarted then
		gAudioPlayer:playAudio()
		self.audioStarted = true
	end
	
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
		print(self.timer)
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
		if circleCollision(note.x, note.y, note.radius, self.healthBar.x, self.healthBar.y, self.healthBar.radius - 2.5 * note.radius) then
			note.isDestroyed = true
			--self.healthBar:takeDamage(note.score)
		end
		if note.isDestroyed then
			table.remove(self.notes, k)
		end
	end

	for k, pad in pairs(self.pads) do
		pad:update(dt)
	end

	-- Note Spawning
	self.timer = self.timer + dt
	if self.noteIndex <= #gMapNotes and self.timer >= gMapNotes[self.noteIndex].start_time * self.note_time_multiplier then
		--print(gMapNotes[self.noteIndex].pad)
		self:newNote(20, gMapNotes[self.noteIndex].pad, gMapNotes[self.noteIndex].lane, 1)
		self.noteIndex = self.noteIndex + 1
		--print("Spawned a note! Time is " .. self.timer)
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