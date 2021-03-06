MidiReader = {}
MidiReader.__index = MidiReader

local convertNote = {
  "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None",
  "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None",
  "C1", "C#1", "D1", "Eb1", "E1", "F1", "F#1", "G1", "Ab1", "A1", "Bb1", "B1",
  "C2", "C#2", "D2", "Eb2", "E2", "F2", "F#2", "G2", "Ab2", "A2", "Bb2", "B2", 
  "C3", "C#3", "D3", "Eb3", "E3", "F3", "F#3", "G3", "Ab3", "A3", "Bb3", "B3",
  "C4", "C#4", "D4", "Eb4", "E4", "F4", "F#4", "G4", "Ab4", "A4", "Bb4", "B4",
  "C5", "C#5", "D5", "Eb5", "E5", "F5", "F#5", "G5", "Ab5", "A5", "Bb5", "B5",
  "C6", "C#6", "D6", "Eb6", "E6", "F6", "F#6", "G6", "Ab6", "A6", "Bb6", "B6",
  "C7", "C#7", "D7", "Eb7", "E7", "F7", "F#7", "G7", "Ab7", "A7", "Bb7", "B7",
  "C8",
  "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None",
  "None", "None", "None", "None", "None", "None", "None"
}

function MidiReader:init(filename)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	print(filename)
	if(love.filesystem.getInfo(filename)) then
		self.midiData = MIDI.midi2score(love.filesystem.read(filename))
		
		-- Default tempo, if there are no tempo events in the MIDI file.
		-- Mostly for Ableton-dialect MIDI files, since they lack tempo events.
		local currentTempo = 2500000
		
		for i=2, #self.midiData do
			for j=1, #self.midiData[i] do
				-- note structure: {'note', start_time, duration, channel, note, velocity}
				if self.midiData[i][j][1] == 'set_tempo' then
					currentTempo = self.midiData[i][j][3]
				elseif self.midiData[i][j][1] == 'note' then
					-- assign start times
					-- The mess of math at the end correctly converts the MIDI times into seconds.
					--self.midiData[i][j].start_time = (self.midiData[i][j][2] / 1000) * 125 / (60000000 / currentTempo)
					self.midiData[i][j].start_time = (self.midiData[i][j][2] * currentTempo) / 480000000
					-- assign durations
					self.midiData[i][j].duration = self.midiData[i][j][3]
					-- assign pitch strings
					self.midiData[i][j].pitch = convertNote[self.midiData[i][j][5] - 11]
					-- assign lanes
					--for c=48, 25, -1 do
						--if self.midiData[i][j].pitch == convertNote[c] then
							local absoluteLane = 49 - (self.midiData[i][j][5] - 11)
							self.midiData[i][j].pad = math.ceil(absoluteLane / 3)
							--FIX LANE ASSOC HERE
							self.midiData[i][j].lane = (absoluteLane)
						--end
					--end
					-- assign type
					if self.midiData[i][j][6] <= 45 then
						self.midiData[i][j].type = 1
					elseif self.midiData[i][j][6] > 45 and self.midiData[i][j][6] <= 85 then
						self.midiData[i][j].type = 3
					elseif self.midiData[i][j][6] > 85 then
						self.midiData[i][j].type = 2
					end
				end
				-- table.print(self.midiData[i][j])
			end
		end
	end
	return table.deepcopy(o)
end

function MidiReader:get_notes()
	-- limited to single track MIDIs
	local notes = {}
	--print("\nself.mididata:")
	--table.print(self.midiData)
	for i=2, #self.midiData do
		for j=1, #self.midiData[i] do
			if self.midiData[i][j][1] == 'note' then
				table.insert(notes, self.midiData[i][j])
			end
		end
	end
	--print("\nnotes:")
	--table.print(notes)
	return notes
end
