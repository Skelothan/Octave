PlayState = {}
PlayState.__index = PlayState

function PlayState:newPad(pX, pY, pRadius, pNum)
	color = gCurrentPalette.pad1
	laneColor = gCurrentPalette.laneColor
	if pNum % 2 == 1 then
		color = gCurrentPalette.pad2
		laneColor = gCurrentPalette.laneColor2
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
		laneColor = laneColor
	})
	table.insert(self.lanes, lane11)
	local lane12 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+1), 8),
		laneColor = laneColor
	})
	table.insert(self.lanes, lane12)
	local lane13 = Lane:init({
		padX = pX, 
		padY = pY, 
		padR = pRadius,
		angle = math.oimod((pNum+2), 8),
		laneColor = laneColor
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
			noteType = nNoteType,
			score = 1000
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
	self.song = params.song
	if params.practice then self.practice = true else self.practice = false end
	
	self.submenu = Submenu:init({
		
		x = winWidth/4,
		y = winHeight/2,
		width = winWidth/2,
		font = "AvenirLight32",
		align = "center",
		
		selectedOption = 1,
		
		options = {
			{"Resume", 
			function() 
				local playstate = gStateMachine.current
				gSounds["back"]:stop()
				gSounds["back"]:play()
				if playstate.audioStarted and not playstate.audioEnded then
					gAudioPlayer:playAudio()
				end
				playstate.submenu.active = false
				gIsPaused = false
			end},
			{"Quit", 
			function() 
				local menustate = gStateMachine.current
				gSounds["back"]:stop()
				gSounds["back"]:play()
				gIsPaused = false
				gAudioPlayer:changeAudio(gMenuMusic)
				gAudioPlayer:playAudio()
				gStateMachine:change("menu", {})
			end},
		}
	})
	
	-- Note speed must be constant for correct syncing
	self.speedCoeff = self.song.speedCoeff 
	self.noteSpeed = self.speedCoeff * math.max(love.graphics.getHeight(), love.graphics.getWidth())
	
	self:makePads()
	
	gMidiReader = MidiReader:init(self.song.midi)
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
	self.note_time_multiplier =  125 / self.song.bpm--derived with excel, logic pro, and pain. Works for Drop In, Flip Out at least...
	-- For this track, seems to be equal to 125 / BPM
	--Drop in - 0.7102
	
	--print("Delay before notes: " .. self.delay_before_notes)
	
	self.note_travel_time = ((gSpawnDistance - centerRadius) / self.noteSpeed)
	
	--print("Note travel time: " .. self.note_travel_time)

	--DELAY BEFORE NOTES ENTER - make it longer to make them come sooner
	self.timer = self.delay_before_notes
	self.noteIndex = 1
	
	self.audioStarted = false
	self.audioEnded = false
	gAudioPlayer:stopAudio()
	
	--self.audioDelay = 2 * midiOffset + self.note_travel_time. Old, doesn't work well.
	
	-- Delay before audio syncs to MIDI for Drop In, Flip Out: 85 milliseconds, more or less exactly
	self.audioDelay = 1 / (2 * self.speedCoeff) - self.song.noteDelay 
	gAudioPlayer:changeAudio(love.audio.newSource(self.song.audio, "stream"))
	gAudioPlayer:setLooping(false)
	self.audioDoneTimer = 3
	
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
	if self.submenu.active then
		self:updateSubmenu(dt)
	else
		self:updateNormal(dt)
	end
end


function PlayState:updateNormal(dt)
	--before anything else, check to see if the game is paused, pause if so
	if love.keyboard.wasInput("togglePauseMenu") then
		gAudioPlayer:pauseAudio()
		self.submenu:activate()
		gIsPaused = true
	end
	
	self.audioDelay = math.max(self.audioDelay-dt, 0)
	if self.audioDelay == 0 and not self.audioStarted then
		gAudioPlayer:playAudio()
		self.audioStarted = true
	end
	
	if not gAudioPlayer:isPlaying() and self.audioStarted then
		self.audioEnded = true
		if self.audioDoneTimer > 0 then
			self.audioDoneTimer = self.audioDoneTimer - dt
		else
			gStateMachine:change("gameOver", {
			score = self.healthBar.score, 
			isWon = true,
			file = self.song.highScoreFile
		})
		end
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
		
	for k, pad in pairs(self.pads) do
		pad:update(dt)
	end

	-- Pad/note collision
	if love.keyboard.wasInput("topArrow") or love.keyboard.wasInput("bottomArrow") then

		if love.keyboard.wasInput("topArrow") then
			for k, pad in pairs(self.pads) do
				if pad.selected then
					pad:onPress("topArrow")
					break
				end
			end
		end
		if love.keyboard.wasInput("bottomArrow") then
			for k, pad in pairs(self.pads) do
				if pad.selected then
					pad:onPress("bottomArrow")
					break
				end
			end
		end
	end

	for k, pad in pairs(self.pads) do
			if pad.active then
				for j, note in pairs(self.notes) do --notes is populated from within note.lua when spawned
					coll_collides, coll_dist = noteCollision(pad, note)
					
					--[[
					print(note.noteType)
					print("Pad number: " .. k)
					print("Note Type: " .. pad.noteTypePressed);
					print("Note Type abs: " .. self.pads[2].noteTypePressed);
					]]
					if pad.active and coll_collides == true and note.isHit == false and note.noteType == pad.noteTypePressed then
						note:onHit() --TODO: onHit takes in an accuracy parameter, which causes different sounds to be played
						pad.active = false
						--print(coll_dist)
						if coll_dist < 0.1 then -- Perfect
							self.healthBar:incrementScore(note.score)
							self.healthBar:restoreHealth()
							gSounds["noteHitPerfect"]:stop()
							gSounds["noteHitPerfect"]:play()
							self.healthBar:incrementMultiplier()
						elseif coll_dist < 0.3 then -- Great
							self.healthBar:incrementScore(note.score * 0.9)
							self.healthBar:restoreHealth()
							gSounds["noteHitGreat"]:stop()
							gSounds["noteHitGreat"]:play()
							self.healthBar:incrementMultiplier()
						elseif coll_dist < 0.5 then -- Good
							self.healthBar:incrementScore(note.score * 0.75)
							gSounds["noteHitGood"]:stop()
							gSounds["noteHitGood"]:play()
							self.healthBar:incrementMultiplier()
						elseif coll_dist < 1.1 then -- OK
							self.healthBar:incrementScore(note.score * 0.50)
							gSounds["noteHitOk"]:stop()
							gSounds["noteHitOk"]:play()
						else -- Miss
							gSounds["noteMiss"]:stop()
							gSounds["noteMiss"]:play()
							self.healthBar:resetMultiplier()
						end
						
					end
				end
			end
		
	end
	
	-- Note Spawning
	self.timer = self.timer + dt
	if self.noteIndex <= #gMapNotes and self.timer >= gMapNotes[self.noteIndex].start_time * self.note_time_multiplier then
		--print(gMapNotes[self.noteIndex].pad)
		self:newNote(20, gMapNotes[self.noteIndex].pad, gMapNotes[self.noteIndex].lane, gMapNotes[self.noteIndex].type)
		self.noteIndex = self.noteIndex + 1
		--print("Spawned a note! Time is " .. self.timer)
	end
	
	-- Debug: spawning notes
	if love.keyboard.wasInput("unbound") then
		print(self.timer)
	end
	
	for k, note in pairs(self.notes) do
		note:update(dt)
		-- Change directions of notes once they reach center of pad
		if not note.directionChanged then
		--if note.lane ~= 2 and not note.directionChanged then
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
			if not self.practice then self.healthBar:takeDamage(note.score) end
		end
		if note.isDestroyed then
			table.remove(self.notes, k)
		end
	end

	

  --[[
	if love.keyboard.wasInput("unbound") then
		self:spawnNote()
	end
  ]]

	self.healthBar:update(dt)

end

function PlayState:updateSubmenu(dt)
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
	
	if self.submenu.active then
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.rectangle("fill", 0, 0, winWidth, winHeight)
		love.graphics.setColor(gCurrentPalette.menuText)
		love.graphics.printf("Paused", gFonts["AvenirLight64"], 0, winHeight*0.10, winWidth, "center")
		self.submenu:render()
	end
	
	-- Debug:
	--love.graphics.printf("Time: " .. self.timer, 0, 0, winWidth, "left")
	--love.graphics.printf("Note Type: " .. self.pads[2].noteTypePressed, 0, 0, winWidth, "left")
end